//
//  PassRateView.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 24.01.2021.
//

import UIKit

class PassRateCell: UITableViewCell {
    private lazy var titleLabel = makeTitleLabel()
    private lazy var progressView = makeProgressView()
    private lazy var percentLabel = makePercentLabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PassRateCell {
    func setup(percent: Double) {
        percentLabel.attributedText = "\(percent)%".attributed(with: PassRateCell.textAttr)
        progressView.setProgress(min(Float(percent / 100), 1.0), animated: true)
    }
}

// MARK: Lazy initialization
private extension PassRateCell {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.attributedText = "Stats.PassRate.Title".localized.attributed(with: PassRateCell.textAttr)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        view.progressTintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePercentLabel() -> UILabel {
        let view = UILabel()
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    static let textAttr = TextAttributes()
        .textColor(.white)
        .font(Fonts.SFProRounded.bold(size: 21.scale))
        .lineHeight(25.scale)
}

// MARK: Make constraints
private extension PassRateCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.scale),
            titleLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -15.scale),
            titleLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.scale),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.scale),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.scale),
            progressView.heightAnchor.constraint(equalToConstant: 3)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20.scale),
            percentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15.scale),
            percentLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -15.scale)
        ])
    }
}

// MARK: Private
private extension PassRateCell {
    func configure() {
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = UIColor(integralRed: 95, green: 70, blue: 245)
    }
}

#if DEBUG
import SwiftUI
@available(iOS 13.0, *)
struct PassRateCell_Previews: PreviewProvider {
    
    struct PassRateCellRepresentable: UIViewRepresentable {
        func makeUIView(context: Context) -> PassRateCell {
            let cell = PassRateCell()
            cell.setup(percent: 30)
            return cell
        }
        func updateUIView(_ uiView: PassRateCell, context: Context) {
            
        }
    }

    static var previews: some View {
        return PassRateCellRepresentable().frame(width: 343, height: 80, alignment: .center)
    }
}
#endif
