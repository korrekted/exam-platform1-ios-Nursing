//
//  OAgeButton.swift
//  Nursing
//
//  Created by Андрей Чернышев on 10.02.2022.
//

import UIKit

final class OAgeButton: UIButton {
    var age: String? {
        didSet {
            let attrs = TextAttributes()
                .textColor(Appearance.greyColor)
                .font(Fonts.SFProRounded.semiBold(size: 19.scale))
                .lineHeight(26.6.scale)
                .textAlignment(.center)
            label.attributedText = age?.attributed(with: attrs)
        }
    }
    
    var select: Bool = false {
        didSet {
            layer.borderColor = select ? Appearance.mainColor.cgColor : UIColor.clear.cgColor
            layer.borderWidth = select ? 4.scale : 0
        }
    }
    
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension OAgeButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OAgeButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
