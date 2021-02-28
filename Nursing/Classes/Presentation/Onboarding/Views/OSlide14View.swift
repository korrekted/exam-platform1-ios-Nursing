//
//  OSlide14View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 25.01.2021.
//

import UIKit

final class OSlide14View: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var analyzeLabel = makeAnalyziLabel()
    lazy var progressView = makeProgressView()
    lazy var percentLabel = makePercentLabel()
    
    private var timer: Timer?
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        progressView.progressAnimation(duration: 4.5)
        calculatePercent()
    }
}

// MARK: Private
private extension OSlide14View {
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
            
            if percent <= 20 {
                self?.analyzeLabel.text = "Onboarding.Slide14.Preloader1".localized
            } else if percent <= 40 {
                self?.analyzeLabel.text = "Onboarding.Slide14.Preloader2".localized
            } else if percent <= 60 {
                self?.analyzeLabel.text = "Onboarding.Slide14.Preloader3".localized
            } else if percent <= 80 {
                self?.analyzeLabel.text = "Onboarding.Slide14.Preloader4".localized
            } else {
                self?.analyzeLabel.text = "Onboarding.Slide14.Preloader5".localized
            }
            
            if seconds >= duration {
                timer.invalidate()
                
                self?.finish()
            }
        }
    }
    
    func finish() {
        timer = nil
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.onNext()
        }
    }
}

// MARK: Make constraints
private extension OSlide14View {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 134.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 210.scale),
            progressView.heightAnchor.constraint(equalToConstant: 210.scale),
            progressView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 293.scale : 200.scale)
        ])
        
        NSLayoutConstraint.activate([
            analyzeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100.scale),
            analyzeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100.scale),
            analyzeLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 35.scale)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
            percentLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlide14View {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Slide14.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAnalyziLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = Fonts.SFProRounded.bold(size: 19.scale)
        view.textColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> OProgressView {
        let view = OProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.textAlignment = .center
        view.font = Fonts.SFProRounded.bold(size: 45.scale)
        view.textColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
