//
//  ReviewView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 17.06.2022.
//

import UIKit

final class ReviewView: UIView {
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
private extension ReviewView {
    func initialize() {
        backgroundColor = Appearance.backgroundColor
    }
}

// MARK: Make constraints
private extension ReviewView {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension ReviewView {
    
}
