//
//  WelcomeSlide3CellView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 08.02.2022.
//

import UIKit

final class WelcomeSlide3CellView: UIView {
    var title: String? {
        didSet {
            let attrs = TextAttributes()
                .textColor(Appearance.greyColor)
                .font(Fonts.SFProRounded.semiBold(size: 17.scale))
                .lineHeight(23.8.scale)
            titleLabel.attributedText = title?.attributed(with: attrs)
        }
    }
    
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension WelcomeSlide3CellView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            imageView.widthAnchor.constraint(equalToConstant: 26.scale),
            imageView.heightAnchor.constraint(equalToConstant: 26.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 62.scale),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WelcomeSlide3CellView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Welcome.Checked")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.alpha = 0.8
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
