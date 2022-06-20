//
//  QuestionViewerViewModel.swift
//  Nursing
//
//  Created by Андрей Чернышев on 20.06.2022.
//

import RxSwift
import RxCocoa

final class QuestionViewerViewModel {
    lazy var elements = makeElements()
    
    private lazy var textSize = makeTextSize()
    
    private let question: BehaviorRelay<Question>
    private let answeredIds: BehaviorRelay<[Int]>
    
    private lazy var questionManager = QuestionManager()
    private lazy var profileManager = ProfileManager()
    
    init(question: Question, answeredIds: [Int]) {
        self.question = BehaviorRelay(value: question)
        self.answeredIds = BehaviorRelay(value: answeredIds)
    }
}

// MARK: Private
private extension QuestionViewerViewModel {
    func makeElements() -> Driver<[TestingCellType]> {
        Driver
            .combineLatest(question.asDriver(), answeredIds.asDriver(), textSize)
            .map { [weak self] question, answeredIds, textSize -> [TestingCellType] in
                guard let self = self else {
                    return []
                }
                
                var result = [TestingCellType]()
                
                let questionCells = self.makeQuestionCells(question: question, textSize: textSize)
                result.append(contentsOf: questionCells)
                
                let answersCells = self.makeAnswersCells(question: question, answeredIds: answeredIds, textSize: textSize)
                result.append(contentsOf: answersCells)
                
                let explanationCells = self.makeExplanationCells(question: question)
                result.append(contentsOf: explanationCells)
                
                if let reference = question.reference, !reference.isEmpty {
                    result.append(.reference(reference))
                }
                
                return result
            }
    }
    
    func makeQuestionCells(question: Question, textSize: TextSize) -> [TestingCellType] {
        let content: [QuestionContentType] = [
            question.image.map { .image($0) },
            question.video.map { .video($0) }
        ].compactMap { $0 }
        
        return [
            !content.isEmpty ? .content(content) : nil,
            .question(question.question, html: question.questionHtml, textSize)
        ].compactMap { $0 }
    }
    
    func makeAnswersCells(question: Question, answeredIds: [Int], textSize: TextSize) -> [TestingCellType] {
        let result = question.answers.compactMap { answer -> AnswerResultElement in
            let state: AnswerState = answeredIds.contains(answer.id)
                    ? answer.isCorrect ? .correct : .error
                    : answer.isCorrect ? question.multiple ? .warning : .correct : .initial
            
            return AnswerResultElement(answer: answer.answer,
                                       answerHtml: answer.answerHtml,
                                       image: answer.image,
                                       state: state)
        }
        
        return [.result(result, textSize)]
    }
    
    func makeExplanationCells(question: Question) -> [TestingCellType] {
        let explanation: [TestingCellType]
    
        let explanationText: TestingCellType?
        if (question.explanation != nil || question.explanationHtml != nil) {
            explanationText = .explanationText(question.explanation ?? "", html: question.explanationHtml ?? "")
        } else {
            explanationText = nil
        }

        let explanationImages = question.media.map { TestingCellType.explanationImage($0)}

        if explanationText != nil || !explanationImages.isEmpty {
            explanation = [.explanationTitle] + explanationImages + [explanationText].compactMap { $0 }
        } else {
            explanation = []
        }
        
        return explanation
    }
    
    func makeTextSize() -> Driver<TextSize> {
        profileManager
            .obtainStudySettings()
            .map { $0.textSize }
            .asDriver(onErrorDriveWith: .never())
    }
}
