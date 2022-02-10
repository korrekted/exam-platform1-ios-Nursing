//
//  OSlide4View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlideGoalsView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(title: "Onboarding.Goals.Cell1")
    lazy var cell2 = makeCell(title: "Onboarding.Goals.Cell2")
    lazy var cell3 = makeCell(title: "Onboarding.Goals.Cell3")
    lazy var cell4 = makeCell(title: "Onboarding.Goals.Cell4")
    lazy var cell5 = makeCell(title: "Onboarding.Goals.Cell5")
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        changeEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared
            .logEvent(name: "Goals Screen", parameters: [:])
    }
}

// MARK: Private
private extension OSlideGoalsView {
    @objc
    func selected(sender: UIButton) {
        guard let button = sender as? OAgeButton else {
            return
        }
        
        button.select.toggle()
        
        changeEnabled()
    }
    
    func changeEnabled() {
        let isEmpty = [
            cell1,
            cell2,
            cell3,
            cell4,
            cell5
        ]
        .filter { $0.select }
        .isEmpty

        button.isEnabled = !isEmpty
        button.alpha = isEmpty ? 0.4 : 1
    }
}

// MARK: Make constraints
private extension OSlideGoalsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 117.scale : 70.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.widthAnchor.constraint(equalToConstant: 323.scale),
            cell1.heightAnchor.constraint(equalToConstant: 73.scale),
            cell1.centerXAnchor.constraint(equalTo: centerXAnchor),
            cell1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 40.scale : 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.widthAnchor.constraint(equalToConstant: 323.scale),
            cell2.heightAnchor.constraint(equalToConstant: 73.scale),
            cell2.centerXAnchor.constraint(equalTo: centerXAnchor),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.widthAnchor.constraint(equalToConstant: 323.scale),
            cell3.heightAnchor.constraint(equalToConstant: 73.scale),
            cell3.centerXAnchor.constraint(equalTo: centerXAnchor),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.widthAnchor.constraint(equalToConstant: 323.scale),
            cell4.heightAnchor.constraint(equalToConstant: 73.scale),
            cell4.centerXAnchor.constraint(equalTo: centerXAnchor),
            cell4.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell5.widthAnchor.constraint(equalToConstant: 323.scale),
            cell5.heightAnchor.constraint(equalToConstant: 73.scale),
            cell5.centerXAnchor.constraint(equalTo: centerXAnchor),
            cell5.topAnchor.constraint(equalTo: cell4.bottomAnchor, constant: 15.scale)
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
private extension OSlideGoalsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.blackColor)
            .font(Fonts.SFProRounded.black(size: 27.scale))
            .lineHeight(32.4.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Goals.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String) -> OAgeButton {
        let view = OAgeButton()
        view.select = false
        view.age = title.localized
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
            .lineHeight(23.scale)
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
