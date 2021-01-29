//
//  OSlide4Cell.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 24.01.2021.
//

import UIKit

final class OSlide4Cell: PaddingLabel {
    var isSelected = false {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OSlide4Cell {
    func initialize() {
        backgroundColor = UIColor.white
        
        layer.masksToBounds = true
        layer.cornerRadius = 20.scale
        
        topInset = 15.scale
        bottomInset = 15.scale
        leftInset = 20.scale
        rightInset = 20.scale
        
        textColor = UIColor.black
        font = Fonts.SFProRounded.semiBold(size: 17.scale)
    }
    
    func update() {
        layer.borderWidth = isSelected ? 2.scale : 0
        layer.borderColor = isSelected ? UIColor(integralRed: 95, green: 70, blue: 245).cgColor : UIColor.white.cgColor
    }
}
