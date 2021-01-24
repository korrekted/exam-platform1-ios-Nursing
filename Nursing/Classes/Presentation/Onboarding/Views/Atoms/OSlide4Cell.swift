//
//  OSlide4Cell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlide4Cell: UIView {
    lazy var label = makeLabel()
    lazy var imageView = makeImageView()
    
    var isSelected = false {
        didSet {
            imageView.isHidden = !isSelected
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
private extension OSlide4Cell {
    func initialize() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 20.scale
        layer.borderWidth = 1.scale
        layer.borderColor = UIColor.white.cgColor
    }
}

// MARK: Make constraints
private extension OSlide4Cell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20.scale),
            imageView.heightAnchor.constraint(equalToConstant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OSlide4Cell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: "Onboarding.Slide4.Checked")
        view.contentMode = .scaleAspectFit
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
