//
//  BottomView.swift
//  FNP
//
//  Created by Vitaliy Zagorodnov on 11.07.2021.
//

import UIKit

final class BottomView: UIView {
    enum State {
        case confirm
        case submit
        case back
        case hidden
    }
    
    lazy var bottomButton = makeBottomButton()
    lazy var nextButton = makeNextButton()
    lazy var preloader = makePreloader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if bottomButton.isHidden && nextButton.isHidden {
            return false
        }
        
        return bounds.contains(point)
    }
}

// MARK: Public
extension BottomView {
    func setup(state: BottomView.State) {
        switch state {
        case .confirm:
            bottomButton.setAttributedTitle("Question.Continue".localized.attributed(with: Self.buttonAttr), for: .normal)
        case .submit:
            bottomButton.setAttributedTitle("Question.Submit".localized.attributed(with: Self.buttonAttr), for: .normal)
        case .back:
            bottomButton.setAttributedTitle("Question.BackToStudying".localized.attributed(with: Self.buttonAttr), for: .normal)
        case .hidden:
            break
        }
        
        bottomButton.isHidden = state == .hidden
    }
}

// MARK: Private
private extension BottomView {
    func initialize() {
        backgroundColor = .clear
    }
    
    static let buttonAttr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 20.scale))
        .lineHeight(23.scale)
        .textColor(.white)
        .textAlignment(.center)
}

// MARK: Make constraints
private extension BottomView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            bottomButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            bottomButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            bottomButton.topAnchor.constraint(equalTo: topAnchor),
            bottomButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            nextButton.topAnchor.constraint(equalTo: topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            preloader.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            preloader.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            preloader.topAnchor.constraint(equalTo: topAnchor),
            preloader.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension BottomView {
    func makeBottomButton() -> UIButton {
        let view = UIButton()
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = Appearance.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> UIButton {
        let view = UIButton()
        view.setAttributedTitle("Question.NextQuestion".localized.attributed(with: Self.buttonAttr), for: .normal)
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = Appearance.mainColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> TestBottomSpinner {
        let view = TestBottomSpinner()
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = Appearance.mainColor
        view.stop()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
