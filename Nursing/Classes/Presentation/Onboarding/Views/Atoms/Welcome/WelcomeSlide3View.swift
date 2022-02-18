//
//  WelcomeSlide3View.swift
//  FNP
//
//  Created by Andrey Chernyshev on 09.07.2021.
//

import UIKit

final class WelcomeSlide3View: UIView {
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(title: "Onboarding.Welcome.Cell3.Info1".localized)
    lazy var cell2 = makeCell(title: "Onboarding.Welcome.Cell3.Info2".localized)
    lazy var cell3 = makeCell(title: "Onboarding.Welcome.Cell3.Info3".localized)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension WelcomeSlide3View {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 92.scale),
            imageView.widthAnchor.constraint(equalToConstant: 136.scale),
            imageView.heightAnchor.constraint(equalToConstant: 120.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale),
            cell1.heightAnchor.constraint(equalToConstant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 17.scale),
            cell2.heightAnchor.constraint(equalToConstant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 17.scale),
            cell3.heightAnchor.constraint(equalToConstant: 26.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WelcomeSlide3View {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Welcome3")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.black(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Welcome.Cell3.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String) -> WelcomeSlide3CellView {
        let view = WelcomeSlide3CellView()
        view.backgroundColor = UIColor.clear
        view.title = title
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
