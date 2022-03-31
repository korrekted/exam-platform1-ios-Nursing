//
//  OAgeView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 10.02.2022.
//

import UIKit

final class OSlideAgeView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var age18Button = makeAgeButton(age: "Onboarding.Age.18-24".localized)
    lazy var age25Button = makeAgeButton(age: "Onboarding.Age.25-34".localized)
    lazy var age35Button = makeAgeButton(age: "Onboarding.Age.35-44".localized)
    lazy var age45Button = makeAgeButton(age: "Onboarding.Age.45+".localized)
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        changeEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideAgeView {
    @objc
    func selected(sender: UIButton) {
        guard let button = sender as? OAgeButton else {
            return
        }
        
        [
            age18Button,
            age25Button,
            age35Button,
            age45Button
        ].forEach { $0.select = false }
        
        button.select = true
        
        changeEnabled()
    }
    
    func changeEnabled() {
        let isEmpty = [
            age18Button,
            age25Button,
            age35Button,
            age45Button
        ]
        .filter { $0.select }
        .isEmpty

        button.isEnabled = !isEmpty
        button.alpha = isEmpty ? 0.4 : 1
    }
}

// MARK: Make constraints
private extension OSlideAgeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 117.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            age18Button.widthAnchor.constraint(equalToConstant: 323.scale),
            age18Button.heightAnchor.constraint(equalToConstant: 73.scale),
            age18Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age18Button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            age25Button.widthAnchor.constraint(equalToConstant: 323.scale),
            age25Button.heightAnchor.constraint(equalToConstant: 73.scale),
            age25Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age25Button.topAnchor.constraint(equalTo: age18Button.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            age35Button.widthAnchor.constraint(equalToConstant: 323.scale),
            age35Button.heightAnchor.constraint(equalToConstant: 73.scale),
            age35Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age35Button.topAnchor.constraint(equalTo: age25Button.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            age45Button.widthAnchor.constraint(equalToConstant: 323.scale),
            age45Button.heightAnchor.constraint(equalToConstant: 73.scale),
            age45Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age45Button.topAnchor.constraint(equalTo: age35Button.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            button.heightAnchor.constraint(equalToConstant: 60.scale),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -70.scale : -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideAgeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.black(size: 27.scale))
            .lineHeight(32.4.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Age.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAgeButton(age: String) -> OAgeButton {
        let view = OAgeButton()
        view.select = false
        view.age = age
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.addTarget(self, action: #selector(selected), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
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
}
