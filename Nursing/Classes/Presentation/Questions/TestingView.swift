//
//  TestingView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//
import UIKit

final class TestingView: UIView {
    lazy var progressView = makeProgressView()
    lazy var closeButton = makeCloseButton()
    lazy var continueButton = makeBottomButton(title: "Question.Continue".localized)
    lazy var submitButton = makeBottomButton(title: "Question.Submit".localized)
    lazy var nextButton = makeNextButton()
    lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TestingView {
    func initialize() {
        backgroundColor = UIColor(integralRed: 242, green: 245, blue: 252)
    }
}

// MARK: Make constraints
private extension TestingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 30.scale),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10.scale),
            closeButton.centerYAnchor.constraint(equalTo: progressView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: 20.scale),
            progressView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.scale),
            progressView.rightAnchor.constraint(equalTo: closeButton.leftAnchor),
            progressView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.heightAnchor.constraint(equalToConstant: 60.scale),
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70.scale)
        ])
        
        NSLayoutConstraint.activate([
            submitButton.heightAnchor.constraint(equalToConstant: 60.scale),
            submitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26.scale),
            submitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26.scale),
            submitButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70.scale)
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
private extension TestingView {
    func makeTableView() -> QuestionTableView {
        let view = QuestionTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
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
    
    func makeBottomButton(title: String) -> UIButton {
        let attr = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 20.scale))
            .lineHeight(23.scale)
            .textColor(.white)
            .textAlignment(.center)
        
        let view = UIButton()
        view.setAttributedTitle(title.attributed(with: attr), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30.scale
        view.isHidden = true
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
        view.layer.shadowColor = color.withAlphaComponent(0.05).cgColor
        view.layer.shadowOffset = CGSize(width: 4.scale, height: 20.scale)        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
