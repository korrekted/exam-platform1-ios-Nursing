//
//  OExplanationCell.swift
//  Nursing
//
//  Created by Виталий Загороднов on 17.02.2022.
//

import UIKit

class OExplanationCell: UITableViewCell {
    private lazy var explanationLabel = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OExplanationCell {
    func setup(explanation: String) {
        let explanationAttr = TextAttributes()
            .font(Fonts.SFProRounded.bold(size: 17.scale))
            .textColor(Appearance.greyColor)
            .dictionary
        
        let messageAttr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .textColor(Appearance.greyColor)
            .dictionary
        
        let expAttrText = NSAttributedString(string: "Onboarding.OSlideTestQuestion.Explanation".localized, attributes: explanationAttr)
        let messageAttrText = NSAttributedString(string: explanation, attributes: messageAttr)
        
        let attributedText = NSMutableAttributedString()
        
        attributedText.append(expAttrText)
        attributedText.append(messageAttrText)
        
        explanationLabel.attributedText = attributedText
    }
}

private extension OExplanationCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension OExplanationCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            explanationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26.scale),
            explanationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26.scale),
            explanationLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            explanationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OExplanationCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0
        contentView.addSubview(view)
        return view
    }
}
