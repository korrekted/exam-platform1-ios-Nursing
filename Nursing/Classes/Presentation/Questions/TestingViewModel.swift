//
//  TestingViewModel.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//

import RxSwift
import RxCocoa

final class TestingViewModel {
    let didTapNext = PublishRelay<Void>()
    let didTapConfirm = PublishRelay<Void>()
    let selectedAnswers = BehaviorRelay<AnswerElement?>(value: nil)
    
    lazy var question = makeQuestion()
    lazy var showNextButton = makeShowNext()
    
    private lazy var questionManager = QuestionManagerCore()
    private lazy var courseManager = CoursesManagerCore()
    private lazy var testElement = makeTest().share(replay: 1, scope: .forever)
    private lazy var answers = currentAnswers().share(replay: 1, scope: .forever)
}

// MARK: Private
private extension TestingViewModel {
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
        let questions = testElement.compactMap { $0?.questions }
        
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
    
    func makeTest() -> Observable<Test?> {
        guard let courseId = courseManager.getSelectedCourse()?.id else {
            return .just(nil)
        }
        
        return questionManager
            .retrieveTenSet(courseId: courseId)
            .asObservable()
            .catchAndReturn(nil)
    }
    
    func makeShowNext() -> Driver<Bool> {
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
                    .map { !($0 ?? false) }
                    .asObservable()
                    
            }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
    }
    
    func makeMockTest() -> Observable<Test?> {
        let answers = [
            Answer(id: 1, answer: "Answer 1", isCorrect: false),
            Answer(id: 2, answer: "Answer 2", isCorrect: false),
            Answer(id: 3, answer: "Answer 3", isCorrect: true),
            Answer(id: 4, answer: "Answer 4", isCorrect: false)]
        
        let questionText = "Which of the following tests should be ordered initially for the infant presenting with biliious emesis"
        
        let explanation = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Consequat neque vel sagittis malesuada elit sed sit diam dictum. Venenatis vehicula neque purus risus leo, augue. Volutpat turpis in augue leo egestas integer feugiat eu sodales. Eget mattis turpis vitae aenean euismod lorem urna. Id potenti sagittis, sodales quis aliquet massa. Faucibus at quis neque, amet nisi. Ut etiam condimentum neque adipiscing id vitae, amet. Interdum."
        
        let question1 = Question(
            id: 1,
            image: URL(string: "https://rutasochi.ru/uploads/images/news/gori_sochi.jpg"),
            video: URL(string: "https://www.radiantmediaplayer.com/media/big-buck-bunny-360p.mp4"),
            question: "\(1) " + questionText,
            answers: answers,
            multiple: true,
            explanation: explanation
        )
        
        let question2 = Question(
            id: 2,
            image: nil,
            video: nil,
            question: "\(2) " + questionText,
            answers: answers,
            multiple: true,
            explanation: explanation
        )
        
        let question3 = Question(
            id: 3,
            image: nil,
            video: nil,
            question: "\(3) " + questionText,
            answers: answers,
            multiple: false,
            explanation: explanation
        )
        
        let question4 = Question(
            id: 4,
            image: nil,
            video: nil,
            question: "\(4) " + questionText,
            answers: answers,
            multiple: false,
            explanation: explanation
        )
        
        let question5 = Question(
            id: 5,
            image: nil,
            video: nil,
            question: "\(5) " + questionText,
            answers: answers,
            multiple: false,
            explanation: explanation
        )
        
        let question6 = Question(
            id: 6,
            image: nil,
            video: nil,
            question: "\(6) " + questionText,
            answers: answers,
            multiple: false,
            explanation: explanation
        )
        
        let question7 = Question(
            id: 7,
            image: nil,
            video: nil,
            question: "\(7) " + questionText,
            answers: answers,
            multiple: false,
            explanation: explanation
        )
        
        let question8 = Question(
            id: 8,
            image: nil,
            video: nil,
            question: "\(8) " + questionText,
            answers: answers,
            multiple: true,
            explanation: explanation
        )
        
        let question9 = Question(
            id: 9,
            image: nil,
            video: nil,
            question: "\(9) " + questionText,
            answers: answers,
            multiple: true,
            explanation: explanation
        )
        
        let question10 = Question(
            id: 10,
            image: nil,
            video: nil,
            question: "\(10) " + questionText,
            answers: answers,
            multiple: true,
            explanation: explanation
        )
        
        let test = Test(
            paid: false,
            userTestId: 0,
            questions: [question1, question2, question3, question4, question5, question6, question7, question8, question9, question10]
        )
        
        return .just(test)
    }
}

// MARK: Additional
private extension TestingViewModel {
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
