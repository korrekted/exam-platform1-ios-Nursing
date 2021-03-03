//
//  AnswerView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 30.01.2021.
//
import UIKit
import RxCocoa

final class AnswerView: UIView {
    private lazy var iconView = makeIconView()
    private lazy var answerLabel = makeAnswerLabel()
    private lazy var imageView = makeImageView()
    private let tapGesture = UITapGestureRecognizer()
    private var labelBottomConstraint: NSLayoutConstraint?
    
    var state: State = .initial {
        didSet {
            setState(state: state)
        }
    }
        
    private override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension AnswerView {
    enum State {
        case initial, correct, error, warning, selected
    }
    
    func setAnswer(answer: String, image: URL?) {
        let attrs = TextAttributes()
            .font(Fonts.SFProRounded.regular(size: 17.scale))
            .textColor(.black)
            .lineHeight(20.scale)
        
        if let imageUrl = image {
            do {
                try imageView.image = UIImage(data: Data(contentsOf: imageUrl))
                needUpdateConstraints()
            } catch {
                
            }
        }
        
        answerLabel.attributedText = answer.attributed(with: attrs)
    }
    
    var didTap: Signal<Void> {
        tapGesture.rx.event
            .map { _ in () }
            .asSignal(onErrorSignalWith: .empty())
    }
}

// MARK: Private
private extension AnswerView {
    func initialize() {
        layer.cornerRadius = 20.scale
        addGestureRecognizer(tapGesture)
        state = .initial
    }
    
    func setState(state: State) {
        switch state {
        case .initial:
            layer.borderWidth = 0
            layer.borderColor = UIColor.clear.cgColor
            backgroundColor = .white
            iconView.image = nil
        case .selected:
            layer.borderWidth = 3.scale
            layer.borderColor = UIColor(integralRed: 95, green: 70, blue: 245).cgColor
            backgroundColor = .white
            iconView.image = nil
        case .correct:
            let correctColor = UIColor(integralRed: 46, green: 190, blue: 161)
            layer.borderWidth = 3.scale
            layer.borderColor = correctColor.cgColor
            backgroundColor = correctColor.withAlphaComponent(0.15)
            iconView.tintColor = correctColor
            iconView.image = UIImage(named: "Question.Correct")
        case .error:
            let errorColor = UIColor(integralRed: 254, green: 105, blue: 88)
            layer.borderWidth = 3.scale
            layer.borderColor = errorColor.cgColor
            backgroundColor = errorColor.withAlphaComponent(0.15)
            iconView.tintColor = errorColor
            iconView.image = UIImage(named: "Question.Error")
        case .warning:
            let warningColor = UIColor(integralRed: 254, green: 168, blue: 88)
            layer.borderWidth = 3.scale
            layer.borderColor = warningColor.cgColor
            backgroundColor = warningColor.withAlphaComponent(0.15)
            iconView.tintColor = warningColor
            iconView.image = UIImage(named: "Question.Warning")
        }
    }
}

// MARK: Make constraints
private extension AnswerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            answerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            answerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 19.scale),
            answerLabel.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -20.scale)
        ])
        
        labelBottomConstraint = answerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -19.scale)
        labelBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        
    }
    
    func needUpdateConstraints() {
        labelBottomConstraint?.isActive = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 124.scale),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.scale),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44.scale),
            imageView.trailingAnchor.constraint(equalTo: iconView.leadingAnchor)
        ])
        
        labelBottomConstraint = imageView.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 10.scale)
        labelBottomConstraint?.isActive = true
    }
}

// MARK: Lazy initialization
private extension AnswerView {
    func makeAnswerLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
