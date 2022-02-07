//
//  OExperienceCell.swift
//  Nursing
//
//  Created by Андрей Чернышев on 07.02.2022.
//

import UIKit

final class OExperienceCell: UIButton {
    var image: UIImage? {
        didSet {
            iconView.image = image
        }
    }
    
    var title: String? {
        didSet {
            let attrs = TextAttributes()
                .textColor(UIColor(integralRed: 19, green: 24, blue: 42))
                .font(Fonts.SFProRounded.bold(size: 19.scale))
                .lineHeight(22.8.scale)
            headerLabel.attributedText = title?.attributed(with: attrs)
        }
    }
    
    var subTitle: String? {
        didSet {
            let attrs = TextAttributes()
                .textColor(UIColor(integralRed: 75, green: 81, blue: 102))
                .font(Fonts.SFProRounded.regular(size: 17.scale))
                .lineHeight(20.29.scale)
            subTitleLabel.attributedText = subTitle?.attributed(with: attrs)
        }
    }
    
    lazy var iconView = makeImageView()
    lazy var headerLabel = makeLabel()
    lazy var subTitleLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OExperienceCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 121.scale),
            iconView.heightAnchor.constraint(equalToConstant: 142.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 128.scale),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 128.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OExperienceCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
