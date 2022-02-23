//
//  OSlideTestQuestionView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 14.02.2022.
//

import UIKit

final class OSlideTestQuestionView: OSlideView {
    lazy var button = makeButton()
    private lazy var tableView = makeQuestionTable()
    private lazy var numberLabel = makeNumberLabel()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        setupNumber(for: step)
        makeConstraints()
        change(enabled: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension OSlideTestQuestionView {
    func setup(question: Question) {
        let answers: [OTestCellType] = question.answers
            .map { .answer(OAnswerElement(id: $0.id, answer: $0.answer ?? "", image: $0.image, state: .initial, isCorrect: $0.isCorrect)) }
        
        let questionCell = OTestCellType.question(question.question, html: question.questionHtml)
        
        let elements: [OTestCellType] = [questionCell] + answers
        
        let questionElement = OQuestionElement(
            id: question.id,
            elements: elements,
            isResult: false
        )
        
        tableView.setup(question: questionElement) { [weak self] value in
            self?.change(enabled: true)
            
            guard let correctAnswer = question.answers.first(where: { $0.isCorrect }) else {
                return
            }
            
            let isCorrect = correctAnswer.id == value.id
            let resultAnswer = OAnswerElement(
                id: value.id,
                answer: value.answer,
                image: value.image,
                state: isCorrect ? .correct : .error,
                isCorrect: value.isCorrect
            )
            
            let explanationCell = question.explanation.map { OTestCellType.explanation($0)}
            let elements: [OTestCellType] = [questionCell, .answer(resultAnswer), .comment(isError: !isCorrect, comment: correctAnswer.answer), explanationCell].compactMap { $0 }
            
            let questionElement = OQuestionElement(
                id: question.id,
                elements: elements,
                isResult: true
            )
            
            self?.tableView.setup(question: questionElement)
        }
    }
}

private extension OSlideTestQuestionView {
    func setupNumber(for step: OnboardingView.Step) {
        let firstNumber: String
        
        switch step {
        case .testQuestion1:
            firstNumber = "1"
        case .testQuestion2:
            firstNumber = "2"
        case .testQuestion3:
            firstNumber = "3"
        case .testQuestion4:
            firstNumber = "4"
        case .testQuestion5:
            firstNumber = "5"
        default:
            firstNumber = ""
        }
        
        guard !firstNumber.isEmpty else { return }
        
        let firstAttr = TextAttributes()
            .font(Fonts.SFProRounded.bold(size: 19.scale))
            .textColor(Appearance.greyColor)
            .dictionary
        
        let secondAttr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 15.scale))
            .textColor(Appearance.greyColor)
            .dictionary
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: firstNumber, attributes: firstAttr))
        attributedText.append(NSAttributedString(string: "/5", attributes: secondAttr))
        numberLabel.attributedText = attributedText
    }
    
    func change(enabled: Bool) {
        button.isEnabled = enabled
        button.alpha = enabled ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension OSlideTestQuestionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 117.scale : 70.scale),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -70.scale : -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 15.scale),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -17.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideTestQuestionView {
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .textAlignment(.center)
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.mainColor
        view.layer.cornerRadius = 30.scale
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeQuestionTable() -> OQuestionTableView {
        let view = OQuestionTableView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        return view
    }
    
    func makeNumberLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
