//
//  TestViewModel.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import RxSwift
import RxCocoa

final class TestViewModel {
    var tryAgain: ((Error) -> (Observable<Void>))?
    
    var activeSubscription = false
    
    let testType = BehaviorRelay<TestType?>(value: nil)
    let didTapMark = PublishRelay<Bool>()
    let didTapNext = PublishRelay<Void>()
    let didTapConfirm = PublishRelay<Void>()
    let didTapSubmit = PublishRelay<Void>()
    let didTapRestart = PublishRelay<Int>()
    let answers = BehaviorRelay<AnswerElement?>(value: nil)
    
    lazy var courseName = makeCourseName()
    lazy var isSavedQuestion = makeIsSavedQuestion()
    lazy var progress = makeProgress()
    lazy var score = makeScore()
    lazy var testFinishElement = makeTestFinishElement()
    lazy var questions = makeQuestions()
    lazy var question = makeQuestion()
    lazy var isEndOfTest = endOfTest()
    lazy var userTestId = makeUserTestId()
    lazy var bottomViewState = makeBottomState()
    lazy var testMode = makeTestMode()
    lazy var course = makeCourse()
    lazy var needPayment = makeNeedPayment()
    
    lazy var loadTestActivityIndicator = RxActivityIndicator()
    lazy var sendAnswerActivityIndicator = RxActivityIndicator()
    
    private lazy var observableRetrySingle = ObservableRetrySingle()
    
    private lazy var testElement = makeTest()
    private lazy var selectedAnswers = makeSelectedAnswers()
    private lazy var currentAnswers = makeCurrentAnswers()
    private lazy var studySettings = makeStudySettings()
    private lazy var timer = makeTimer()
    
    private lazy var questionManager = QuestionManager()
    private lazy var profileManager = ProfileManager()
}

// MARK: Private
private extension TestViewModel {
    func makeCourseName() -> Driver<String> {
        course
            .map { $0?.name ?? "" }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeIsSavedQuestion() -> Driver<Bool> {
        let initial = question
            .asObservable()
            .map { $0.isSaved }
        
        let isSavedQuestion = didTapMark
            .withLatestFrom(question) { ($0, $1.id) }
            .flatMapFirst { [weak self] isSaved, questionId -> Observable<Bool> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<Bool> {
                    let request = isSaved
                        ? self.questionManager.removeSavedQuestion(questionId: questionId)
                        : self.questionManager.saveQuestion(questionId: questionId)

                    return request
                        .map { !isSaved }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }

                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
            }
        
        return Observable
            .merge(initial, isSavedQuestion)
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeProgress() -> Driver<String> {
        testType
            .flatMapLatest { [weak self] type -> Driver<String> in
                guard let self = self else {
                    return .just("")
                }
                
                let result: Driver<String>
                if case .timed = type {
                    result = self.timer
                        .map { $0.secondsToString() }
                        .asDriver(onErrorDriveWith: .never())
                } else {
                    result = self.question
                        .map { String(format: "Question.QuestionProgress".localized, $0.index, $0.questionsCount) }
                }
                
                return result
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeScore() -> Driver<Float> {
        question
            .map { questionElement -> Float in
                Float(questionElement.index) / Float(questionElement.questionsCount)
            }
    }
    
    func makeTestFinishElement() -> Driver<TestFinishElement> {
        let didFinishTest = timer
            .compactMap { $0 == 0 ? () : nil }
            .withLatestFrom(userTestId)
            .flatMap { [weak self] userTestId -> Single<Int> in
                guard let self = self else {
                    return .never()
                }
                
                return self.questionManager
                    .finishTest(userTestId: userTestId)
                    .map { userTestId }
            }
        
        let submit = didTapSubmit
            .withLatestFrom(userTestId)
        
        return Observable.merge(didFinishTest, submit)
            .withLatestFrom(courseName) { ($0, $1) }
            .withLatestFrom(testType) { ($0.0, $0.1, $1) }
            .compactMap { userTestId, courseName, testType -> TestFinishElement? in
                guard let testType = testType else {
                    return nil
                }
                
                return TestFinishElement(userTestId: userTestId,
                                         courseName: courseName,
                                         testType: testType)
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeQuestion() -> Driver<QuestionElement> {
        didTapRestart
            .mapToVoid()
            .startWith(Void())
            .flatMapLatest { [weak self] void -> Driver<QuestionElement> in
                guard let self = self else {
                    return .never()
                }
                
                return Observable<Action>
                    .merge(
                        self.didTapNext.debounce(.microseconds(500), scheduler: MainScheduler.instance).map { _ in .next },
                        self.questions.map { .elements($0) }
                    )
                    .scan((nil, []), accumulator: self.currentQuestionAccumulator)
                    .compactMap { $0.0 }
                    .asDriver(onErrorDriveWith: .empty())
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQuestions() -> Observable<[QuestionElement]> {
        let questions = testElement
            .compactMap { $0.questions }

        let mode = testMode.asObservable()
        let courseName = courseName.asObservable()
        let studySettings = studySettings.asObservable()
        
        return questions
            .flatMapLatest { [weak self] questions -> Observable<[QuestionElement]> in
                guard let self = self else {
                    return .never()
                }
                
                return Observable
                    .combineLatest(self.selectedAnswers, mode, courseName, studySettings)
                    .map { (questions, $0, $1, $2, $3) }
                    .scan([], accumulator: self.questionAccumulator)
            }
    }
    
    func makeSelectedAnswers() -> Observable<AnswerElement?> {
        didTapConfirm
            .withLatestFrom(currentAnswers)
            .startWith(nil)
    }
    
    func makeTest() -> Observable<Test> {
        let load = loadTest()
        let restart = restartTest()
        
        return Observable.merge(load, restart)
    }
    
    func loadTest() -> Observable<Test> {
        func trigger(error: Error) -> Observable<Void> {
            guard let tryAgain = self.tryAgain?(error) else {
                return .empty()
            }
            
            return tryAgain
        }
        
        let courseId = course
            .compactMap { $0?.id }
            .asObservable()
        let type = testType
            .compactMap { $0 }
            .asObservable()
        
        return Observable
            .combineLatest(courseId, type)
            .flatMapLatest { [weak self] courseId, type -> Observable<Test> in
                guard let self = self else {
                    return .empty()
                }
                
                let test: Single<Test?>
                
                switch type {
                case let .get(testId):
                    test = self.questionManager.obtain(courseId: courseId,
                                                       testId: testId,
                                                       time: nil,
                                                       activeSubscription: self.activeSubscription)
                case .tenSet:
                    test = self.questionManager.obtainTenSet(courseId: courseId,
                                                             activeSubscription: self.activeSubscription)
                case .failedSet:
                    test = self.questionManager.obtainFailedSet(courseId: courseId,
                                                                activeSubscription: self.activeSubscription)
                case .qotd:
                    test = self.questionManager.obtainQotd(courseId: courseId,
                                                           activeSubscription: self.activeSubscription)
                case .randomSet:
                    test = self.questionManager.obtainRandomSet(courseId: courseId,
                                                                activeSubscription: self.activeSubscription)
                case .saved:
                    test = self.questionManager.obtainSavedSet(courseId: courseId,
                                                               activeSubscription: self.activeSubscription)
                case .timed(let minutes):
                    test = self.questionManager.obtain(courseId: courseId,
                                                       testId: nil,
                                                       time: minutes,
                                                       activeSubscription: self.activeSubscription)
                }
                
                return test
                    .compactMap { $0 }
                    .asObservable()
                    .trackActivity(self.loadTestActivityIndicator)
                    .retry(when: { errorObs in
                        errorObs.flatMap { error in
                            trigger(error: error)
                        }
                    })
            }
    }
    
    func restartTest() -> Observable<Test> {
        didTapRestart
            .flatMapLatest { [weak self] userTestId -> Observable<Test> in
                guard let self = self else {
                    return .empty()
                }
                
                func source() -> Single<Test> {
                    self.questionManager
                        .obtainAgainTest(userTestId: userTestId)
                        .flatMap { test -> Single<Test> in
                            guard let test = test else {
                                return .error(ContentError(.notContent))
                            }
                            
                            return .just(test)
                        }
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.loadTestActivityIndicator)
            }
    }
    
    func makeNeedPayment() -> Signal<Bool> {
        testElement
            .map { [weak self] element in
                guard let self = self else { return false }
                return self.activeSubscription ? false : element.paid ? true : false
            }
            .asSignal(onErrorSignalWith: .empty())
    }

    func makeUserTestId() -> Observable<Int> {
        testElement
            .compactMap { $0.userTestId }
    }
    
    func makeCurrentAnswers() -> Observable<AnswerElement?> {
        Observable
            .merge(answers.asObservable(),
                   didTapNext.map { _ in nil },
                   didTapRestart.map { _ in nil }
            )
    }
    
    func endOfTest() -> Driver<Bool> {
        selectedAnswers
            .compactMap { $0 }
            .withLatestFrom(testElement) {
                ($0, $1.userTestId)
            }
            .flatMapLatest { [weak self] element, userTestId -> Observable<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                func source() -> Single<Bool?> {
                    self.questionManager
                        .sendAnswer(
                            questionId: element.questionId,
                            userTestId: userTestId,
                            answerIds: element.answerIds
                        )
                }
                
                func trigger(error: Error) -> Observable<Void> {
                    guard let tryAgain = self.tryAgain?(error) else {
                        return .empty()
                    }
                    
                    return tryAgain
                }
                
                return self.observableRetrySingle
                    .retry(source: { source() },
                           trigger: { trigger(error: $0) })
                    .trackActivity(self.sendAnswerActivityIndicator)
                    .compactMap { $0 }
                    .asObservable()
            }
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeBottomState() -> Driver<BottomView.State> {
        Driver.combineLatest(isEndOfTest, question, currentAnswers.asDriver(onErrorJustReturn: nil))
            .map { isEndOfTest, question, answers -> BottomView.State in
                let isResult = question.elements.contains(where: {
                    guard case .result = $0 else { return false }
                    return true
                })
                
                if question.index == question.questionsCount, question.questionsCount != 1, isResult {
                    return isEndOfTest ? .submit : .hidden
                } else {
                    guard isResult && question.questionsCount == 1 else {
                        return isResult ? .hidden : answers?.answerIds.isEmpty == false ? .confirm : .hidden
                    }
                    
                    return .back
                }
            }
            .startWith(.hidden)
            .distinctUntilChanged()
    }
    
    func makeTestMode() -> Driver<TestMode?> {
        profileManager
            .obtainTestMode(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
    }
    
    func makeCourse() -> Driver<Course?> {
        let initial = profileManager
            .obtainSelectedCourse(forceUpdate: false)
            .asDriver(onErrorJustReturn: nil)
        
        let updated = ProfileMediator.shared
            .changedCourse
            .map { course -> Course? in
                course
            }
            .asDriver(onErrorJustReturn: nil)
        
        return Driver.merge(initial, updated)
    }
    
    func makeStudySettings() -> Driver<StudySettings> {
        profileManager
            .obtainStudySettings()
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeTimer() -> Observable<Int> {
        testElement
            .withLatestFrom(testType)
            .flatMapLatest { testType -> Observable<Int> in
                guard case let .timed(minutes) = testType else {
                    return .empty()
                }
                
                let startTime = CFAbsoluteTimeGetCurrent()
                let seconds = minutes * 60
                
                return Observable<Int>
                    .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
                    .map { _ in Int(CFAbsoluteTimeGetCurrent() - startTime) }
                    .take(until: { $0 >= seconds }, behavior: .inclusive)
                    .map { max(0, seconds - $0) }
                    .distinctUntilChanged()
            }
    }
}

// MARK: Additional
private extension TestViewModel {
    enum Action {
        case next
        case previos
        case elements([QuestionElement])
    }
    
    var questionAccumulator: ([QuestionElement], ([Question], AnswerElement?, TestMode?, String, StudySettings)) -> [QuestionElement] {
        return { [weak self] (old, args) -> [QuestionElement] in
            let (questions, answers, testMode, courseName, studySettings) = args
            
            guard !old.isEmpty else {
                return questions.enumerated().map { index, question in
                    let answers = question.answers.map { PossibleAnswerElement(id: $0.id,
                                                                               answer: $0.answer,
                                                                               answerHtml: $0.answerHtml,
                                                                               image: $0.image) }
                    
                    let content: [QuestionContentType] = [
                        question.image.map { .image($0) },
                        question.video.map { .video($0) }
                    ].compactMap { $0 }
                    
                    let elements: [TestingCellType] = [
                        !content.isEmpty ? .content(content) : nil,
                        .question(question.question, html: question.questionHtml, studySettings.textSize),
                        .answers(answers, studySettings.textSize)
                    ].compactMap { $0 }
                    
                    var referenceCellType = [TestingCellType]()
                    if let reference = question.reference, !reference.isEmpty {
                        referenceCellType.append(.reference(reference))
                    }
                    
                    return QuestionElement(
                        id: question.id,
                        elements: elements + referenceCellType,
                        isMultiple: question.multiple,
                        index: index + 1,
                        isAnswered: question.isAnswered,
                        questionsCount: questions.count,
                        isSaved: question.isSaved
                    )
                }
            }
            
            guard let currentAnswers = answers, let currentQuestion = questions.first(where: { $0.id == currentAnswers.questionId }) else {
                return old
            }
            
            let currentMode = questions.count > 1 ? testMode : .fullComplect
            
            guard let index = old.firstIndex(where: { $0.id == currentAnswers.questionId }) else {
                return old
            }
            let currentElement = old[index]
            let newElements = currentElement.elements.compactMap { value -> TestingCellType? in
                if case .reference = value { return nil }
                
                guard case .answers = value else { return value }
                
                let result = currentQuestion.answers.map { answer -> AnswerResultElement in
                    let state: AnswerState
                    
                    if currentMode == .onAnExam {
                        state = .initial
                    } else {
                        state = currentAnswers.answerIds.contains(answer.id)
                            ? answer.isCorrect ? .correct : .error
                            : answer.isCorrect ? currentQuestion.multiple ? .warning : .correct : .initial
                    }
                    
                    return AnswerResultElement(answer: answer.answer,
                                               answerHtml: answer.answerHtml,
                                               image: answer.image,
                                               state: state)
                }
                
                if currentQuestion.multiple {
                    let isCorrect = !result.contains(where: { $0.state == .warning || $0.state == .error })
                    self?.logAnswerAnalitycs(isCorrect: isCorrect, courseName: courseName)
                } else {
                    let isCorrect = result.contains(where: { $0.state == .correct })
                    self?.logAnswerAnalitycs(isCorrect: isCorrect, courseName: courseName)
                }
                
                return .result(result, studySettings.textSize)
            }
            
            let explanation: [TestingCellType]
            
            if [.none, .fullComplect].contains(testMode) {
                let explanationText: TestingCellType?
                if (currentQuestion.explanation != nil || currentQuestion.explanationHtml != nil) {
                    explanationText = .explanationText(currentQuestion.explanation ?? "", html: currentQuestion.explanationHtml ?? "")
                } else {
                    explanationText = nil
                }
                
                let explanationImages = currentQuestion.media.map { TestingCellType.explanationImage($0)}
                
                if explanationText != nil || !explanationImages.isEmpty {
                    explanation = [.explanationTitle] + explanationImages + [explanationText].compactMap { $0 }
                } else {
                    explanation = []
                }
                
            } else {
                explanation = []
            }
            
            var referenceCellType = [TestingCellType]()
            if let reference = currentQuestion.reference, !reference.isEmpty {
                referenceCellType.append(.reference(reference))
            }
            
            let newElement = QuestionElement(
                id: currentElement.id,
                elements: newElements + explanation + referenceCellType,
                isMultiple: currentElement.isMultiple,
                index: currentElement.index,
                isAnswered: currentElement.isAnswered,
                questionsCount: currentElement.questionsCount,
                isSaved: currentElement.isSaved
            )
            var result = old
            result[index] = newElement
            return result
        }
    }
    
    var currentQuestionAccumulator: ((QuestionElement?, [QuestionElement]), Action) -> (QuestionElement?, [QuestionElement]) {
        return { old, action -> (QuestionElement?, [QuestionElement]) in
            let (currentElement, elements) = old
            
            switch action {
            case let .elements(questions):
                // Проверка для вопроса дня, чтобы была возможность отобразить вопрос,
                // если юзер уже на него отвечал
                guard questions.count > 1 else { return (questions.first, questions) }
                
                let withoutAnswered = questions.filter { !$0.isAnswered }
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }) ?? 0
                return (withoutAnswered[safe: index], questions)
            case .next:
                let withoutAnswered = elements.filter { !$0.isAnswered }
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }).map { $0 + 1 } ?? 0
                return (withoutAnswered[safe: index] ?? currentElement, elements)
            case .previos:
                let withoutAnswered = elements.filter { !$0.isAnswered }
                let index = withoutAnswered.firstIndex(where: { $0.id == currentElement?.id }).map { $0 - 1 } ?? 0
                return (withoutAnswered[safe: index] ?? currentElement, elements)
            }
        }
    }
}

private extension TestViewModel {
    func logAnswerAnalitycs(isCorrect: Bool, courseName: String) {
        guard let type = testType.value else {
            return
        }
        let name = isCorrect ? "Question Answered Correctly" : "Question Answered Incorrectly"
        let mode = TestAnalytics.name(mode: type)
        
        AmplitudeManager.shared
            .logEvent(name: name, parameters: ["course" : courseName, "mode": mode])
    }
}

private extension Int {
    func secondsToString() -> String {
        let seconds = self
        var mins = 0
        var secs = seconds
        if seconds >= 60 {
            mins = Int(seconds / 60)
            secs = seconds - (mins * 60)
        }
        
        return String(format: "%02d:%02d", mins, secs)
    }
}
