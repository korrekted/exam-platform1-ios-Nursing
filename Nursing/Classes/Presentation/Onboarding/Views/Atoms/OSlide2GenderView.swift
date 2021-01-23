//
//  OSlide2GenderView.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlide2GenderView: UIView {
    lazy var imageView = makeImageView()
    lazy var label = makeLabel()
    
    var isSelected = false {
        didSet {
            updateColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlide2GenderView {
    func initialize() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 20.scale
        layer.borderWidth = 1.scale
        layer.borderColor = UIColor.white.cgColor
    }
    
    func updateColor() {
        layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.white.cgColor
    }
}

// MARK: Make constraints
private extension OSlide2GenderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlide2GenderView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.font = Fonts.SFProRounded.semiBold(size: 17.scale)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
