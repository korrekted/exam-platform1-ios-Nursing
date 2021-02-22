//
//  OSlideQuestionView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlideQuestionView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var questionLabel = makeQuestionLabel()
    lazy var yesButton = makeYesButton()
    lazy var noButton = makeNoButton()

    private let questionKey: String
    
    init(step: OnboardingView.Step, questionKey: String) {
        self.questionKey = questionKey
        
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OSlideQuestionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 134.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 321.scale : 240.scale)
        ])
        
        NSLayoutConstraint.activate([
            yesButton.widthAnchor.constraint(equalToConstant: 93.scale),
            yesButton.heightAnchor.constraint(equalToConstant: 93.scale),
            yesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65.scale),
            yesButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -70.scale : -30.scale)
        ])
        
        NSLayoutConstraint.activate([
            noButton.widthAnchor.constraint(equalToConstant: 93.scale),
            noButton.heightAnchor.constraint(equalToConstant: 93.scale),
            noButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -65.scale),
            noButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -70.scale : -30.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlideQuestionView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Slide10.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeQuestionLabel() -> PaddingLabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let view = PaddingLabel()
        view.numberOfLines = 0
        view.leftInset = 15.scale
        view.rightInset = 15.scale
        view.topInset = 36.scale
        view.bottomInset = 36.scale
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        view.attributedText = questionKey.localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeYesButton() -> OSlideQuestiionButton {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onNext))
        
        let view = OSlideQuestiionButton()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.imageView.image = UIImage(named: "Onboarding.Slide10.Yes")
        view.label.text = "Onboarding.Yes".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNoButton() -> OSlideQuestiionButton {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onNext))
        
        let view = OSlideQuestiionButton()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.imageView.image = UIImage(named: "Onboarding.Slide10.No")
        view.label.text = "Onboarding.No".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
