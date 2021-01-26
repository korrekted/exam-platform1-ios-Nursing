//
//  MainStatsDescriptionView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 25.01.2021.
//

import UIKit

class MainStatsDescriptionView: UIView {
    private lazy var stackView = makeStackView()
    private lazy var testTakenLineView = makeLineView()
    private lazy var longestStreakLineView = makeLineView()
    private lazy var answeredQuestionsLineView = makeLineView()
    private lazy var correctAnswersLineView = makeLineView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: Public
extension MainStatsDescriptionView {
    func setup(value: MainStatsElement) {
        testTakenLineView.setup(title: "Stats.MainRate.TestsTake".localized, value: "\(value.testTaken)")
        longestStreakLineView.setup(title: "Stats.MainRate.LongestStreak".localized, value: "\(value.longestStreak)")
        answeredQuestionsLineView.setup(title: "Stats.MainRate.AnsweredQuestions".localized, value: "\(value.answeredQuestions)")
        correctAnswersLineView.setup(title: "Stats.MainRate.CorrectAnswers".localized, value: "\(value.correctAnswers)")
    }
}

// MARK: Make constraints
private extension MainStatsDescriptionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure() {
        layer.cornerRadius = 20
        
        [testTakenLineView, makeSeparatorView(), longestStreakLineView, makeSeparatorView(), answeredQuestionsLineView, makeSeparatorView(), correctAnswersLineView].forEach(stackView.addArrangedSubview)
    }
}

// MARK: Lazy initialization
private extension MainStatsDescriptionView {
    func makeLineView() -> MainStatsDescriptionLineView {
        let view = MainStatsDescriptionLineView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 95, green: 70, blue: 245).withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

private extension MainStatsDescriptionView {
    
}

#if DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct MainStatsDescriptionView_Previews: PreviewProvider {
    
    struct MainStatsDescriptionViewRepresentable: UIViewRepresentable {
        func makeUIView(context: Context) -> MainStatsDescriptionView {
            let view = MainStatsDescriptionView()
            view.setup(value: .init(passRate: 100, testTaken: 200, correctAnswers: 300, questionsTaken: 400, longestStreak: 500, answeredQuestions: 600))
            return view
        }
        func updateUIView(_ uiView: MainStatsDescriptionView, context: Context) {
            
        }
    }

    static var previews: some View {
        return MainStatsDescriptionViewRepresentable().frame(width: 343, height: 203, alignment: .center)
    }
}
#endif
