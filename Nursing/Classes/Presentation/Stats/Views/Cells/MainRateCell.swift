//
//  MainRateCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 24.01.2021.
//

import UIKit

class MainRateCell: UITableViewCell {
    private lazy var stackStatsView = makeStackView()
    private lazy var testTakenStatsView = makeMainStatsView()
    private lazy var correctAnswersStatsView = makeMainStatsView()
    private lazy var questionsTakenStatsView = makeMainStatsView()
    private lazy var statsDescriptionView = makeStatsDescriptionView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MainRateCell {
    func setup(model: MainStatsElement) {
        testTakenStatsView.setPercent(percent: model.testTaken)
        correctAnswersStatsView.setPercent(percent: model.correctAnswers)
        questionsTakenStatsView.setPercent(percent: model.questionsTaken)
        statsDescriptionView.setup(value: model)
    }
}

// MARK: Private
private extension MainRateCell {
    func configure() {
        [testTakenStatsView, correctAnswersStatsView, questionsTakenStatsView].forEach(stackStatsView.addArrangedSubview)
        testTakenStatsView.setup(
            title: "Stats.MainRate.TestsTake".localized,
            color: UIColor(integralRed: 83, green: 189, blue: 224)
        )
        correctAnswersStatsView.setup(
            title: "Stats.MainRate.CorrectAnswers".localized,
            color: UIColor(integralRed: 95, green: 70, blue: 245)
        )
        questionsTakenStatsView.setup(
            title: "Stats.MainRate.QuestionsTaken".localized,
            color: UIColor(integralRed: 198, green: 42, blue: 80)
        )
    }
}

// MARK: Make constraints
private extension MainRateCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            stackStatsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackStatsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackStatsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackStatsView.bottomAnchor.constraint(equalTo: statsDescriptionView.topAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            statsDescriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statsDescriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            statsDescriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension MainRateCell {
    func makeMainStatsView() -> MainStatsView {
        let view = MainStatsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeStatsDescriptionView() -> MainStatsDescriptionView {
        let view = MainStatsDescriptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}


#if DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct MainRateCell_Previews: PreviewProvider {
    
    struct MainRateCellRepresentable: UIViewRepresentable {
        func makeUIView(context: Context) -> MainRateCell {
            let cell = MainRateCell()
            cell.setup(model: .init(passRate: 10, testTaken: 20, correctAnswers: 30, questionsTaken: 40, longestStreak: 50, answeredQuestions: 60))
            return cell
        }
        func updateUIView(_ uiView: MainRateCell, context: Context) {
            
        }
    }

    static var previews: some View {
        return MainRateCellRepresentable().frame(width: 343, height: 268, alignment: .center)
    }
}
#endif
