//
//  OImproveCell.swift
//  FNP
//
//  Created by Andrey Chernyshev on 12.07.2021.
//

import UIKit

final class OImproveCell: UIView {
    var title: String? {
        didSet {
            let attrs = TextAttributes()
                .textColor(Appearance.blackColor)
                .font(Fonts.SFProRounded.semiBold(size: 17.scale))
                .lineHeight(20.29.scale)
                .textAlignment(.center)
            label.attributedText = title?.attributed(with: attrs)
        }
    }
    
    lazy var label = makeLabel()
    
    var isSelected = false {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OImproveCell {
    func update() {
        layer.borderColor = isSelected ? Appearance.mainColor.cgColor : UIColor.clear.cgColor
        layer.borderWidth = isSelected ? 4.scale : 0
    }
}

// MARK: Make constraints
private extension OImproveCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OImproveCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
