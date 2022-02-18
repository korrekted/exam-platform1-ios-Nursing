//
//  OAnswerCell.swift
//  Nursing
//
//  Created by Виталий Загороднов on 15.02.2022.
//

import Foundation
import UIKit

final class OAnswerCell: UITableViewCell {
    
    private lazy var answerView = makeAnswerView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        answerView.state =  isSelected ? .selected : state ?? .initial
    }
    
    private var state: AnswerView.State?
}

extension OAnswerCell {
    static func height(for element: OAnswerElement, with width: CGFloat) -> CGFloat {
        sizingCell.setup(element: element)
        return sizingCell.contentView.systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height + 1.scale
    }

    private static let sizingCell = OAnswerCell()
 }

// MARK: Public
extension OAnswerCell {
    func setup(element: OAnswerElement) {
        answerView.setAnswer(answer: element.answer, image: element.image)
        
        switch element.state {
        case .initial:
            answerView.state = .initial
        case .correct:
            answerView.state = .correct
        case .warning:
            answerView.state = .warning
        case .error:
            answerView.state = .error
        }
        
        state = answerView.state
    }
}

// MARK: Private
private extension OAnswerCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension OAnswerCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            answerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.scale),
            answerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26.scale),
            answerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26.scale),
            answerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: Lazy initialization
private extension OAnswerCell {
    func makeAnswerView() -> AnswerView {
        let view = AnswerView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

