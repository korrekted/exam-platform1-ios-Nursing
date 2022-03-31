//
//  OSlideWelcomeView.swift
//  FNP
//
//  Created by Andrey Chernyshev on 09.07.2021.
//

import UIKit

final class OSlideWelcomeView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var slide1View = makeSlide1View()
    lazy var slide2View = makeSlide2View()
    lazy var slide3View = makeSlide3View()
    lazy var indicatorView = makeIndicatorView()
    lazy var button = makeButton()
    
    private lazy var slide1LeadingConstraint = NSLayoutConstraint()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlideWelcomeView {
    func initialize() {
        indicatorView.index = 1
        
        AmplitudeManager.shared
            .logEvent(name: "Welcome Screen", parameters: ["number": 1])
    }
    
    @objc
    func didTapped() {
        indicatorView.index = indicatorView.index + 1
        
        guard indicatorView.index <= 3 else {
            onNext()
            return
        }
        
        AmplitudeManager.shared
            .logEvent(name: "Welcome Screen", parameters: ["number": indicatorView.index])
        
        scroll()
    }
    
    func scroll() {
        let index = indicatorView.index
        
        slide1LeadingConstraint.isActive = false
        
        switch index {
        case 1:
            slide1LeadingConstraint.constant = 32.scale
        case 2:
            slide1LeadingConstraint.constant = -311.scale + 16.scale
        case 3:
            slide1LeadingConstraint.constant = -311.scale * 2
        default:
            break
        }
        
        slide1LeadingConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else {
                return
            }
            
            self.layoutIfNeeded()
        })
    }
}

// MARK: Make constraints
private extension OSlideWelcomeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 84.scale : 44.scale)
        ])
        
        slide1LeadingConstraint = slide1View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale)
        NSLayoutConstraint.activate([
            slide1View.widthAnchor.constraint(equalToConstant: 311.scale),
            slide1View.heightAnchor.constraint(equalToConstant: 398.scale),
            slide1LeadingConstraint,
            slide1View.bottomAnchor.constraint(equalTo: indicatorView.topAnchor, constant: -15.scale)
        ])
        
        NSLayoutConstraint.activate([
            slide2View.widthAnchor.constraint(equalToConstant: 311.scale),
            slide2View.heightAnchor.constraint(equalToConstant: 398.scale),
            slide2View.leadingAnchor.constraint(equalTo: slide1View.trailingAnchor, constant: 16.scale),
            slide2View.bottomAnchor.constraint(equalTo: indicatorView.topAnchor, constant: -15.scale)
        ])
        
        NSLayoutConstraint.activate([
            slide3View.widthAnchor.constraint(equalToConstant: 311.scale),
            slide3View.heightAnchor.constraint(equalToConstant: 398.scale),
            slide3View.leadingAnchor.constraint(equalTo: slide2View.trailingAnchor, constant: 16.scale),
            slide3View.bottomAnchor.constraint(equalTo: indicatorView.topAnchor, constant: -15.scale)
        ])
        
        NSLayoutConstraint.activate([
            indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 8.scale),
            indicatorView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: ScreenSize.isIphoneXFamily ? -50.scale : -22.scale)
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
private extension OSlideWelcomeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.black(size: 32.scale))
            .lineHeight(38.4.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Welcome.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSlide1View() -> WelcomeSlide1View {
        let view = WelcomeSlide1View()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSlide2View() -> WelcomeSlide2View {
        let view = WelcomeSlide2View()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSlide3View() -> WelcomeSlide3View {
        let view = WelcomeSlide3View()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIndicatorView() -> WelcomeSlideIndicatorView {
        let view = WelcomeSlideIndicatorView()
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
        view.setAttributedTitle("Onboarding.Welcome.Button".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.mainColor
        view.layer.cornerRadius = 30.scale
        view.addTarget(self, action: #selector(didTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
