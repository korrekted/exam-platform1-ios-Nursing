//
//  OSlide9TagView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlide9TagView: CircleView {
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
private extension OSlide9TagView {
    func update() {
        backgroundColor = isSelected ? UIColor(integralRed: 95, green: 70, blue: 245) : UIColor.white
        label.textColor = isSelected ? UIColor.white : UIColor.black
    }
}

// MARK: Make constraints
private extension OSlide9TagView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlide9TagView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = Fonts.SFProRounded.semiBold(size: 17.scale)
        view.textColor = UIColor.black
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
