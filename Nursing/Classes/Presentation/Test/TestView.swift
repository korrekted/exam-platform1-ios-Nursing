//
//  TestView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//
import UIKit

final class TestView: UIView {
    lazy var progressView = makeProgressView()
    lazy var closeButton = makeCloseButton()
    lazy var bottomButton = makeBottomButton()
    lazy var nextButton = makeNextButton()
    lazy var tableView = makeTableView()
    lazy var gradientView = makeGradientView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Public
extension TestView {
    func setupBottomButton(for state: TestBottomButtonState) {
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
        
        [bottomButton, gradientView].forEach {
            $0.isHidden = state == .hidden
        }
    }
}

// MARK: Private
private extension TestView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 242, green: 245, blue: 252)
    }
    
    static let buttonAttr = TextAttributes()
        .font(Fonts.SFProRounded.regular(size: 20.scale))
        .lineHeight(23.scale)
        .textColor(.white)
        .textAlignment(.center)
}

// MARK: Make constraints
private extension TestView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 30.scale),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.scale),
            closeButton.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 61.scale : 33.scale),
            progressView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.scale),
            progressView.rightAnchor.constraint(equalTo: closeButton.leftAnchor),
            progressView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.heightAnchor.constraint(equalToConstant: 195.scale),
            gradientView.leftAnchor.constraint(equalTo: leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: rightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomButton.heightAnchor.constraint(equalToConstant: 60.scale),
            bottomButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            bottomButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            bottomButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.heightAnchor.constraint(equalToConstant: 40.scale),
            nextButton.widthAnchor.constraint(equalTo: nextButton.heightAnchor),
            nextButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.scale),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -67.scale)
        ])
        
    }
}

// MARK: Lazy initialization
private extension TestView {
    func makeTableView() -> QuestionTableView {
        let view = QuestionTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInsetAdjustmentBehavior = .never
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        let color = UIColor(integralRed: 95, green: 70, blue: 245)
        view.trackTintColor = color.withAlphaComponent(0.3)
        view.progressTintColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(named: "Question.Close"), for: .normal)
        view.tintColor = .black
        addSubview(view)
        return view
    }
    
    func makeBottomButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30.scale
        view.backgroundColor = UIColor(integralRed: 95, green: 70, blue: 245)
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> UIButton {
        let view = UIButton()
        let color = UIColor(integralRed: 30, green: 39, blue: 85)
        
        view.setImage(UIImage(named: "Question.Next"), for: .normal)
        view.tintColor = color
        view.backgroundColor = .white
        view.layer.cornerRadius = 20.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeGradientView() -> UIView {
        let view = UIView()
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(integralRed: 241, green: 244, blue: 251).cgColor]
        gradientLayer.locations = [0, 0.65]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 195.scale))
        
        view.layer.mask = gradientLayer
        view.isUserInteractionEnabled = false
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
