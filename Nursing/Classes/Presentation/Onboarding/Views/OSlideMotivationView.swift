//
//  OSlideMotivationView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 10.02.2022.
//

import UIKit

final class OSlideMotivationView: OSlideView {
    lazy var progressView = makeProgressView()
    lazy var percentLabel = makePercentLabel()
    lazy var percentPlaceholderLabel = makePercentPlaceholderLabel()
    lazy var label = makeLabel()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        progressView.set(progress: 0.4)
    }
}

// MARK: Make constraints
private extension OSlideMotivationView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 261.scale),
            progressView.heightAnchor.constraint(equalToConstant: 130.5.scale),
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 223.scale : 140.scale)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentLabel.topAnchor.constraint(equalTo: progressView.topAnchor, constant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            percentPlaceholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentPlaceholderLabel.topAnchor.constraint(equalTo: percentLabel.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: percentPlaceholderLabel.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 25.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
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
private extension OSlideMotivationView {
    func makeProgressView() -> OMotivationProgressView {
        let view = OMotivationProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.black(size: 60.scale))
            .lineHeight(72.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Motivation.Percent".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePercentPlaceholderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.greyColor.withAlphaComponent(0.8))
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(20.4.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Motivation.PercentPlaceholder".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.successColor)
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(20.4.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Motivation.Label".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs1 = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.black(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let attrs2 = TextAttributes()
            .textColor(Appearance.mainColor)
            .font(Fonts.SFProRounded.black(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let string1 = "Onboarding.Motivation.Title1".localized.attributed(with: attrs1)
        let string2 = "Onboarding.Motivation.Title2".localized.attributed(with: attrs2)
        let string3 = "Onboarding.Motivation.Title3".localized.attributed(with: attrs1)
        
        let result = NSMutableAttributedString()
        result.append(string1)
        result.append(string2)
        result.append(string3)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = result
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs1 = TextAttributes()
            .textColor(Appearance.greyColor.withAlphaComponent(0.8))
            .font(Fonts.SFProRounded.regular(size: 19.scale))
            .lineHeight(26.6.scale)
            .textAlignment(.center)
        
        let attrs2 = TextAttributes()
            .textColor(Appearance.mainColor.withAlphaComponent(0.8))
            .font(Fonts.SFProRounded.regular(size: 19.scale))
            .lineHeight(26.6.scale)
            .textAlignment(.center)
        
        let string1 = "Onboarding.Motivation.SubTitle1".localized.attributed(with: attrs1)
        let string2 = "Onboarding.Motivation.SubTitle2".localized.attributed(with: attrs2)
        let string3 = "Onboarding.Motivation.SubTitle3".localized.attributed(with: attrs1)
        
        let result = NSMutableAttributedString()
        result.append(string1)
        result.append(string2)
        result.append(string3)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = result
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
        view.backgroundColor = Appearance.mainColor
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
