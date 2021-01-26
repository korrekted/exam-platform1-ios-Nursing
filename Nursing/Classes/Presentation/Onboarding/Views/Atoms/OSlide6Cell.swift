//
//  OSlide6Cell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlide6Cell: UIView {
    lazy var outView = makeOutView()
    lazy var innerView = makeInnerView()
    lazy var label = makeLabel()
    
    var isSelected = false {
        didSet {
            innerView.isHidden = !isSelected
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
private extension OSlide6Cell {
    func initialize() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 20.scale
        layer.borderWidth = 1.scale
        layer.borderColor = UIColor.white.cgColor
    }
}

// MARK: Make constraints
private extension OSlide6Cell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            outView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15.scale),
            outView.centerYAnchor.constraint(equalTo: centerYAnchor),
            outView.widthAnchor.constraint(equalToConstant: 16.scale),
            outView.heightAnchor.constraint(equalToConstant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            innerView.widthAnchor.constraint(equalToConstant: 10.scale),
            innerView.heightAnchor.constraint(equalToConstant: 10.scale),
            innerView.centerXAnchor.constraint(equalTo: outView.centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: outView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 41.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 25.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlide6Cell {
    func makeOutView() -> CircleView {
        let view = CircleView()
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 2.scale
        view.layer.borderColor = UIColor(integralRed: 95, green: 70, blue: 245).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInnerView() -> CircleView {
        let view = CircleView()
        view.backgroundColor = UIColor(integralRed: 95, green: 70, blue: 245)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.black
        view.font = Fonts.SFProRounded.semiBold(size: 17.scale)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
