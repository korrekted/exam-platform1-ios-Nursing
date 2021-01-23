//
//  OSlide1View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlide1View: OSlideView {
    lazy var imageView = makeImageView()
    lazy var text1Label = makeText1Label()
    lazy var text2Label = makeText2Label()
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OSlide1View {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 483.scale : 370.scale)
        ])
        
        NSLayoutConstraint.activate([
            text1Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            text1Label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            text1Label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            text2Label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            text2Label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            text2Label.topAnchor.constraint(equalTo: text1Label.bottomAnchor, constant: 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -70.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlide1View {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Slide1")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeText1Label() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 30.scale))
            .lineHeight(35.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Slide1.Text1".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeText2Label() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.semiBold(size: 17.scale))
            .lineHeight(22.scale)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Slide1.Text2".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.SFProRounded.semiBold(size: 20.scale))
            .lineHeight(23.scale)
            .textAlignment(.center)
        
        let view = UIButton()
        view.backgroundColor = UIColor(integralRed: 95, green: 70, blue: 245)
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Onboarding.Slide1.Button".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
