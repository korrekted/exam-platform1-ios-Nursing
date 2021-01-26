//
//  CourseProgressCell.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 24.01.2021.
//

import UIKit

class CourseProgressCell: UITableViewCell {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var stackView = makeStackView()
    private lazy var testTakenProgress = makeProgressView()
    private lazy var correctAnswersProgress = makeProgressView()
    private lazy var questionsTakenProgress = makeProgressView()

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
private extension CourseProgressCell {
    func setup(model: CourseStatsElement) {
        let attr = TextAttributes()
            .textColor(.black)
            .font(Fonts.SFProRounded.bold(size: 17.scale))
            .lineHeight(20.29.scale)
            .textAlignment(.left)
        
        titleLabel.attributedText = model.name.attributed(with: attr)
        testTakenProgress.setup(percent: model.testsTaken, color: UIColor(integralRed: 83, green: 189, blue: 224))
        correctAnswersProgress.setup(percent: model.correctAnswers, color: UIColor(integralRed: 95, green: 70, blue: 245))
        questionsTakenProgress.setup(percent: model.questionsTaken, color: UIColor(integralRed: 198, green: 42, blue: 80))
    }
}

// MARK: Lazy initialization
private extension CourseProgressCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeProgressView() -> CourseProgressView {
        let view = CourseProgressView()
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}

// MARK: Private
private extension CourseProgressCell {
    func configure() {
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .white
        [testTakenProgress, correctAnswersProgress, questionsTakenProgress].forEach(stackView.addArrangedSubview)
    }
}

// MARK: Make constraints
private extension CourseProgressCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.scale),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15.scale),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -5.scale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.scale),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.scale),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.scale)
        ])
    }
}

#if DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct CourseProgressCell_Previews: PreviewProvider {
    
    struct CourseProgressRepresentable: UIViewRepresentable {
        func makeUIView(context: Context) -> CourseProgressCell {
            let cell = CourseProgressCell()
            cell.setup(model: .init(id: 1, name: "Name", testsTaken: 50, correctAnswers: 20, questionsTaken: 30))
            return cell
        }
        func updateUIView(_ uiView: CourseProgressCell, context: Context) {
            
        }
    }

    static var previews: some View {
        return CourseProgressRepresentable().frame(width: 343, height: 165, alignment: .center)
    }
}
#endif
