//
//  OSlideImproveView.swift
//  FNP
//
//  Created by Andrey Chernyshev on 12.07.2021.
//

import UIKit

final class OSlideImproveView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var tag1 = makeTag(title: "Onboarding.Improve.Cell1", tag: 1)
    lazy var tag2 = makeTag(title: "Onboarding.Improve.Cell2", tag: 2)
    lazy var tag3 = makeTag(title: "Onboarding.Improve.Cell3", tag: 3)
    lazy var tag4 = makeTag(title: "Onboarding.Improve.Cell4", tag: 4)
    lazy var tag5 = makeTag(title: "Onboarding.Improve.Cell5", tag: 5)
    lazy var tag6 = makeTag(title: "Onboarding.Improve.Cell6", tag: 6)
    lazy var tag7 = makeTag(title: "Onboarding.Improve.Cell7", tag: 7)
    lazy var tag8 = makeTag(title: "Onboarding.Improve.Cell8", tag: 8)
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step, scope: OnboardingScope) {
        super.init(step: step, scope: scope)
        
        makeConstraints()
        changeEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared
            .logEvent(name: "Improve Screen", parameters: [:])
    }
}

// MARK: Private
private extension OSlideImproveView {
    @objc
    func selected(tapGesture: UITapGestureRecognizer) {
        guard let tagView = tapGesture.view as? OImproveCell else {
            return
        }
        
        tagView.isSelected.toggle()
        
        changeEnabled()
    }
    
    func changeEnabled() {
        let isEmpty = [tag1, tag2, tag3, tag4, tag5, tag6, tag7, tag8]
        .filter { $0.isSelected }
        .isEmpty
        
        button.isEnabled = !isEmpty
        button.alpha = isEmpty ? 0.4 : 1
    }
}

// MARK: Make constraints
private extension OSlideImproveView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 134.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            tag1.widthAnchor.constraint(equalToConstant: 165.scale),
            tag1.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 100.scale : 80.scale),
            tag1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 194.scale),
            tag2.widthAnchor.constraint(equalToConstant: 165.scale),
            tag2.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 100.scale : 80.scale),
            tag2.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            tag3.widthAnchor.constraint(equalToConstant: 165.scale),
            tag3.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 100.scale : 80.scale),
            tag3.topAnchor.constraint(equalTo: tag1.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 194.scale),
            tag4.widthAnchor.constraint(equalToConstant: 165.scale),
            tag4.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 100.scale : 80.scale),
            tag4.topAnchor.constraint(equalTo: tag2.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag5.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            tag5.widthAnchor.constraint(equalToConstant: 165.scale),
            tag5.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 100.scale : 80.scale),
            tag5.topAnchor.constraint(equalTo: tag3.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag6.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 194.scale),
            tag6.widthAnchor.constraint(equalToConstant: 165.scale),
            tag6.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 100.scale : 80.scale),
            tag6.topAnchor.constraint(equalTo: tag4.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag7.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            tag7.widthAnchor.constraint(equalToConstant: 165.scale),
            tag7.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 100.scale : 80.scale),
            tag7.topAnchor.constraint(equalTo: tag5.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            tag8.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 194.scale),
            tag8.widthAnchor.constraint(equalToConstant: 165.scale),
            tag8.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 100.scale : 80.scale),
            tag8.topAnchor.constraint(equalTo: tag6.bottomAnchor, constant: 12.scale)
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
private extension OSlideImproveView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.black(size: 27.scale))
            .lineHeight(32.4.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Improve.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTag(title: String, tag: Int) -> OImproveCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selected(tapGesture:)))
        
        let view = OImproveCell()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.tag = tag
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.isSelected = false
        view.title = title.localized
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
