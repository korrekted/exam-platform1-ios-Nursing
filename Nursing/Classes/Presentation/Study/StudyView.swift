//
//  StudyView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 17.01.2021.
//

import UIKit

final class StudyView: UIView {
    lazy var titleLabel = makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension StudyView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 242, green: 245, blue: 252)
    }
}

// MARK: Make constraints
private extension StudyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 59.scale),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension StudyView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 34.scale))
            .lineHeight(40.scale)
            .letterSpacing(0.37.scale)
        
        let view = UILabel()
        view.attributedText = "Study.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
