//
//  QuestionCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//

import UIKit

class QuestionCell: UITableViewCell {
    
    private lazy var questionLabel = makeQuestionLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension QuestionCell {
    func configure(question: String) {
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 25))
            .textColor(.black)
            .lineHeight(30)
        
        questionLabel.attributedText = question.attributed(with: attr)
    }
}

// MARK: Private
private extension QuestionCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension QuestionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            questionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30.scale),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension QuestionCell {
    func makeQuestionLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
