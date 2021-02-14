//
//  AnswersCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 31.01.2021.
//
import UIKit
import RxSwift

final class AnswersCell: UITableViewCell {
    private lazy var stackView = makeStackView()
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

// MARK: Make Public
extension AnswersCell {
    func configure(answers: [PossibleAnswerElement], isMultiple: Bool, didTap: (([Int]) -> Void)?) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        let answersElements = answers.map { (makeAnswerView(answer: $0.answer), $0) }
        answersElements.map { $0.0 }.forEach(stackView.addArrangedSubview)
        setNeedsLayout()
        
        let test = answersElements.map { answerView, element in
            answerView.didTap
                .asObservable()
                .scan(false) { old, _ in !old }
                .do(onNext: {
                    answerView.state = $0 && isMultiple ? .selected : .initial
                })
                .map { ($0, element) }
        }
        
        Observable.merge(test)
            .scan(Set<PossibleAnswerElement>(), accumulator: { (old, args) -> Set<PossibleAnswerElement> in
                let (isSelected, element) = args
                var result = old
                
                if isSelected {
                    result.insert(element)
                } else {
                    result.remove(element)
                }
                
                return result
            })
            .map { $0.map { $0.id } }
            .take(until: { _ in !isMultiple }, behavior: .inclusive)
            .subscribe(onNext: didTap)
            .disposed(by: disposeBag)
    }
    
    func configure(result: [AnswerResultElement]) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let views = result.map { element -> AnswerView in
            let view = makeAnswerView(answer: element.answer)
            view.isUserInteractionEnabled = false
            switch element.state {
            case .initial:
                view.state = .initial
            case .correct:
                view.state = .correct
            case .error:
                view.state = .error
            }
            
            return view
        }
        
        views.forEach(stackView.addArrangedSubview)
        setNeedsLayout()
    }
}

// MARK: Private
private extension AnswersCell {
    func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension AnswersCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.scale),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
        
        
        let anchor = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.scale)
        anchor.priority = .init(999)
        anchor.isActive = true
    }
}

// MARK: Lazy initialization
private extension AnswersCell {
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.spacing = 15.scale
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeAnswerView(answer: String) -> AnswerView {
        let view = AnswerView()
        view.setAnswer(answer: answer)
        return view
    }
}
