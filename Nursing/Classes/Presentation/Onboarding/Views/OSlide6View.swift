//
//  OSlide6View.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlide6View: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var cell1 = makeCell(title: "Onboarding.Slide6.Cell1", tag: 1)
    lazy var cell2 = makeCell(title: "Onboarding.Slide6.Cell2", tag: 2)
    lazy var cell3 = makeCell(title: "Onboarding.Slide6.Cell3", tag: 3)
    lazy var cell4 = makeCell(title: "Onboarding.Slide6.Cell4", tag: 4)
    lazy var cell5 = makeCell(title: "Onboarding.Slide6.Cell5", tag: 5)
    lazy var button = makeButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlide6View {
    @objc
    func selected(tapGesture: UITapGestureRecognizer) {
        let views = [cell1, cell2, cell3, cell4, cell5]
        
        views.forEach { $0.isSelected = false }
        
        views.first(where: { $0.tag == tapGesture.view?.tag })?.isSelected = true
    }
    
    @objc
    func tapped() {
        let views = [cell1, cell2, cell3, cell4, cell5]
        
        guard views.contains(where: { $0.isSelected }) else {
            return
        }
        
        onNext()
    }
}

// MARK: Make constraints
private extension OSlide6View {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 134.scale : 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            cell1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            cell1.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 233.scale : 130.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            cell2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            cell2.topAnchor.constraint(equalTo: cell1.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            cell3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            cell3.topAnchor.constraint(equalTo: cell2.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            cell4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            cell4.topAnchor.constraint(equalTo: cell3.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            cell5.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17.scale),
            cell5.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17.scale),
            cell5.topAnchor.constraint(equalTo: cell4.bottomAnchor, constant: 15.scale)
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
private extension OSlide6View {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.SFProRounded.bold(size: 27.scale))
            .lineHeight(32.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Slide6.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCell(title: String, tag: Int) -> OSlide6Cell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selected(tapGesture:)))
        
        let view = OSlide6Cell()
        view.tag = tag
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.isSelected = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 20.scale
        view.label.text = title.localized
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
