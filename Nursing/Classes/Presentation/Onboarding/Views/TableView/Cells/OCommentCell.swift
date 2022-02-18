//
//  OCommentCell.swift
//  Nursing
//
//  Created by Виталий Загороднов on 16.02.2022.
//

import UIKit

class OCommentCell: UITableViewCell {
    
    private lazy var commentView = makeCommentView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var commentLabel = makeCommentLabel()
    private lazy var stackView = makeStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OCommentCell {
    func setup(isError: Bool, comment: String? = nil) {
        commentView.backgroundColor = isError ? Appearance.errorColor : Appearance.successColor
        commentLabel.isHidden = !isError
        titleLabel.text = isError
        ? "Onboarding.OSlideTestQuestion.CorrectAnswer".localized
        : "Onboarding.OSlideTestQuestion.Great".localized
        
        commentLabel.text = comment
    }
}

private extension OCommentCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(commentLabel)
    }
}

// MARK: Make constraints
private extension OCommentCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.scale),
            commentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 26.scale),
            commentView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -26.scale),
            commentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: commentView.topAnchor, constant: 25.scale),
            stackView.bottomAnchor.constraint(equalTo: commentView.bottomAnchor, constant: -16.scale),
            stackView.leadingAnchor.constraint(equalTo: commentView.leadingAnchor, constant: 16.scale),
            stackView.trailingAnchor.constraint(equalTo: commentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OCommentCell {
    func makeCommentView() -> BubbleView {
        let view = BubbleView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.font = Fonts.SFProRounded.bold(size: 19.scale)
        view.textColor = .white
        return view
    }
    
    func makeCommentLabel() -> UILabel {
        let view = UILabel()
        view.textColor = .white
        view.font = Fonts.SFProRounded.regular(size: 15.scale)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 6.scale
        view.alignment = .leading
        view.translatesAutoresizingMaskIntoConstraints = false
        commentView.addSubview(view)
        return view
    }
}
