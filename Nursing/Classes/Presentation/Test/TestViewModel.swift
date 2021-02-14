//
//  TestViewModel.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import RxSwift
import RxCocoa

final class TestViewModel {
    
    let testType = BehaviorRelay<TestType?>(value: nil)
    let didTapNext = PublishRelay<Void>()
    let didTapConfirm = PublishRelay<Void>()
    let didTapSubmit = PublishRelay<Void>()
    let selectedAnswers = BehaviorRelay<AnswerElement?>(value: nil)
    
    lazy var question = makeQuestion()
    lazy var isEndOfTest = endOfTest()
    lazy var userTestId = makeUserTestId()
    lazy var bottomViewState = makeBottomState()
    
    private lazy var questionManager = QuestionManagerCore()
    private lazy var courseManager = CoursesManagerCore()
    
    private lazy var testElement = loadTest().share(replay: 1, scope: .forever)
    private lazy var answers = currentAnswers().share(replay: 1, scope: .forever)
}

// MARK: Private
private extension TestViewModel {
    func makeQuestion() -> Driver<QuestionElement> {
        Observable<Action>
            .merge(
                didTapNext.map { _ in .next },
                makeQestions().map { .elements($0) }
            )
            .scan((nil, []), accumulator: currentQuestionAccumulator)
            .compactMap { $0.0 }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    func makeQestions() -> Observable<[QuestionElement]> {
        let questions = testElement.compactMap {
            $0?.questions
            
        }
        
        let dataSource = Observable
            .combineLatest(questions, answers)
            .scan([], accumulator: questionAccumulator)
        
        return dataSource
    }
    
    func currentAnswers() -> Observable<AnswerElement?> {
        let multipleAnswers = didTapConfirm
            .withLatestFrom(selectedAnswers)
            .filter { $0?.isMultiple == true }
        
        let singleAnswer = selectedAnswers
            .filter { $0?.isMultiple == false }
        
        return Observable
            .merge(multipleAnswers, singleAnswer)
            .startWith(nil)
    }
    
    func loadTest() -> Observable<Test?> {
        guard let courseId = courseManager.getSelectedCourse()?.id else {
            return .just(nil)
        }
        
        return testType
            .compactMap { $0 }
            .flatMapLatest { [weak self] type -> Observable<Test?> in
                guard let self = self else { return .empty() }
                
                let test: Single<Test?>
                
                switch type {
                case let .get(testId):
                    test = self.questionManager.retrieve(courseId: courseId, testId: testId)
                case .tenSet:
                    test = self.questionManager.retrieveTenSet(courseId: courseId)
                case .failedSet:
                    test = self.questionManager.retrieveFailedSet(courseId: courseId)
                case .qotd:
                    test = self.questionManager.retrieveQotd(courseId: courseId)
                case .randomSet:
                    test = self.questionManager.retrieveRandomSet(courseId: courseId)
                }
                
                return test
                    .asObservable()
                    .catchAndReturn(nil)
            }
    }

    func makeUserTestId() -> Observable<Int> {
        didTapSubmit
            .withLatestFrom(testElement)
            .compactMap { $0?.userTestId }
    }
    
    func endOfTest() -> Driver<Bool> {
        answers
            .withLatestFrom(testElement) { ($0, $1?.userTestId) }
            .flatMapLatest { [questionManager] element, userTestId -> Observable<Bool> in
                guard let element = element, let userTestId = userTestId else { return .just(false) }
                
                return questionManager
                    .sendAnswer(
                        questionId: element.questionId,
                        userTestId: userTestId,
                        answerIds: element.answerIds
                    )
                    .catchAndReturn(nil)
                    .compactMap { $0 }
                    .asObservable()
                    
            }
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeBottomState() -> Driver<TestBottomButtonState> {
        Driver.combineLatest(isEndOfTest, question)
            .map { isEndOfTest, question -> TestBottomButtonState in
                let isResult = question.elements.contains(where: {
                    guard case .result = $0 else { return false }
                    return true
                })
                
                
                if question.index == question.questionsCount, question.questionsCount != 1, isResult {
                    return isEndOfTest ? .submit : .hidden
                } else {
                    guard isResult && question.questionsCount == 1 else {
                        return isResult ? .hidden : question.isMultiple ? .confirm : .hidden
                    }
                    
                    return .back
                }
            }
            .distinctUntilChanged()
    }
}

// MARK: Additional
private extension TestViewModel {
    enum Action {
        case next
        case previos
        case elements([QuestionElement])
    }
    
    var questionAccumulator: ([QuestionElement], ([Question], AnswerElement?)) -> [QuestionElement] {
        return { (old, args) -> [QuestionElement] in
            let (questions, answers) = args
            guard !old.isEmpty else {
                return questions.enumerated().map { index, question in
                    let answers = question.answers.map { PossibleAnswerElement(id: $0.id, answer: $0.answer) }
                    
                    let content: [QuestionContentType] = [
                        question.image.map { .image($0) },
                        question.video.map { .video($0) }
                    ].compactMap { $0 }
                    
                    let elements: [TestingCellType] = [
                        questions.count > 1 ? .questionsProgress("Question \(index + 1)/\(questions.count)") : nil,
                        !content.isEmpty ? .content(content) : nil,
                        .question(question.question),
                        .answers(answers)
                    ].compactMap { $0 }
                    
                    return QuestionElement(
                        id: question.id,
                        elements: elements,
                        isMultiple: question.multiple,
                        index: index + 1,
                        questionsCount: questions.count
                    )
                }
            }
            
            guard let currentAnswers = answers, let currentQuestion = questions.first(where: { $0.id == currentAnswers.questionId }) else {
                return old
            }
            
            guard let index = old.firstIndex(where: { $0.id == currentAnswers.questionId }) else {
                return old
            }
            let currentElement = old[index]
            let newElements = currentElement.elements.map { value -> TestingCellType in
                guard case .answers = value else { return value }
                
                let result = currentQuestion.answers.map { answer -> AnswerResultElement in
                    let state: AnswerState = currentAnswers.answerIds.contains(answer.id)
                        ? answer.isCorrect ? .correct : .error
                        : answer.isCorrect ? .correct : .initial
                    
                    return AnswerResultElement(answer: answer.answer, state: state)
                }
                
                return .result(result)
            }
            
            let explanation: [TestingCellType] = currentQuestion.explanation.map { [.explanation($0)] } ?? []
            
            let newElement = QuestionElement(
                id: currentElement.id,
                elements: newElements + explanation,
                isMultiple: currentElement.isMultiple,
                index: currentElement.index,
                questionsCount: currentElement.questionsCount
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
                let index = questions.firstIndex(where: { $0.id == currentElement?.id }) ?? 0
                return (questions[safe: index], questions)
            case .next:
                let index = elements.firstIndex(where: { $0.id == currentElement?.id }).map { $0 + 1 } ?? 0
                return (elements[safe: index] ?? currentElement, elements)
            case .previos:
                let index = elements.firstIndex(where: { $0.id == currentElement?.id }).map { $0 - 1 } ?? 0
                return (elements[safe: index] ?? currentElement, elements)
            }
        }
    }
}
