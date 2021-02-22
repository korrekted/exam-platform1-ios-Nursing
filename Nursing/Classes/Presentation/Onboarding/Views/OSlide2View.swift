//
//  OSlide2View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlide2View: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var manView = makeManView()
    lazy var womanView = makeWomanView()
    lazy var button = makeButton()
    
    private var isSelected = false
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlide2View {
    @objc
    func tapped() {
        guard isSelected else {
            return
        }
        
        onNext()
    }
    
    @objc
    func selectedMan() {
        isSelected = true
        
        womanView.isSelected = false
        manView.isSelected = true
    }
    
    @objc
    func selectedWoman() {
        isSelected = true
        
        womanView.isSelected = true
        manView.isSelected = false
    }
}

// MARK: Make constraints
private extension OSlide2View {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 134.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            manView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            manView.widthAnchor.constraint(equalToConstant: 149.scale),
            manView.heightAnchor.constraint(equalToConstant: 149.scale),
            manView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -39.scale)
        ])
        
        NSLayoutConstraint.activate([
            womanView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            womanView.widthAnchor.constraint(equalToConstant: 149.scale),
            womanView.heightAnchor.constraint(equalToConstant: 149.scale),
            womanView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -39.scale)
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
private extension OSlide2View {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Slide2.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeManView() -> OSlide2GenderView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedMan))
        
        let view = OSlide2GenderView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.imageView.image = UIImage(named: "Onboarding.Slide2.Man")
        view.label.text = "Onboarding.Slide2.Man".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWomanView() -> OSlide2GenderView {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedWoman))
        
        let view = OSlide2GenderView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.imageView.image = UIImage(named: "Onboarding.Slide2.Woman")
        view.label.text = "Onboarding.Slide2.Woman".localized
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
        view.setAttributedTitle("Onboarding.Proceed".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
