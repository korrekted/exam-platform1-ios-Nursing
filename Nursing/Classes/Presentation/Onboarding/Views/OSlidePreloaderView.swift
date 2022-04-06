//
//  OSlide14View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit

final class OSlidePreloaderView: OSlideView {
    lazy var progressView = makeProgressView()
    lazy var percentLabel = makePercentLabel()
    lazy var analyzeLabel = makeAnalyziLabel()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var imageView = makeImageView()
    lazy var personLabel = makePersonLabel()
    lazy var feedbackLabel = makeFeedbackLabel()
    lazy var button = makeButton()
    
    private var timer: Timer?
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        progressView.progressAnimation(duration: 4.5)
        calculatePercent()
        
        AmplitudeManager.shared
            .logEvent(name: "Onboarding Screen 7", parameters: [:])
    }
}

// MARK: Private
private extension OSlidePreloaderView {
    func calculatePercent() {
        let duration = Double(4.5)
        var seconds = Double(0)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            seconds += 0.1
            
            var percent = Int(seconds / duration * 100)
            if percent > 100 {
                percent = 100
            }
            self?.percentLabel.text = "\(percent) %"
            
            if seconds >= duration {
                timer.invalidate()
                
                self?.finish()
            }
        }
    }
    
    func finish() {
        timer = nil
        
        button.isHidden = false
    }
}

// MARK: Make constraints
private extension OSlidePreloaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 68.scale),
            progressView.heightAnchor.constraint(equalToConstant: 68.scale),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 51.scale),
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 66.scale : 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            analyzeLabel.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 12.scale),
            analyzeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48.scale),
            analyzeLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
    
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 30.scale : 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 295.scale),
            imageView.heightAnchor.constraint(equalToConstant: 207.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 32.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            personLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            personLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 34.scale : 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            feedbackLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32.scale),
            feedbackLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32.scale),
            feedbackLabel.topAnchor.constraint(equalTo: personLabel.bottomAnchor, constant: 12.scale)
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
private extension OSlidePreloaderView {
    func makeProgressView() -> OProgressView {
        let view = OProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .center
        view.font = Fonts.SFProRounded.bold(size: 15.scale)
        view.textColor = Appearance.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAnalyziLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.greyColor)
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(20.29.scale)
        
        let view = UILabel()
        view.attributedText = "Onboarding.SlidePreloader.Preloader".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mainColor)
            .font(Fonts.SFProRounded.black(size: 24.scale))
            .lineHeight(28.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.SlidePreloader.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.greyColor)
            .font(Fonts.SFProRounded.regular(size: 19.scale))
            .lineHeight(22.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.SlidePreloader.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Onboarding.Preloader")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePersonLabel() -> UILabel {
        let attr1 = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.bold(size: 17.scale))
            .lineHeight(23.8.scale)
            .textAlignment(.center)
        
        let attr2 = TextAttributes()
            .textColor(Appearance.successColor)
            .font(Fonts.SFProRounded.bold(size: 17.scale))
            .lineHeight(23.8.scale)
            .textAlignment(.center)
        
        let string1 = "Onboarding.SlidePreloader.Person1".localized.attributed(with: attr1)
        let string2 = "Onboarding.SlidePreloader.Person2".localized.attributed(with: attr2)
        
        let result = NSMutableAttributedString()
        result.append(string1)
        result.append(string2)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = result
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFeedbackLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.greyColor)
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .lineHeight(23.8.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.SlidePreloader.Feedback".localized.attributed(with: attrs)
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
        view.isHidden = true
        view.backgroundColor = Appearance.mainColor
        view.layer.cornerRadius = 30.scale
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
