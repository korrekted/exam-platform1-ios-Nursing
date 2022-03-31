//
//  SSlideView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 31.03.2022.
//

import UIKit

class SSlideView: UIView {
    var didNextTapped: (() -> Void)?
    
    func moveToThis() {}
    
    @objc
    func onNext() {
        didNextTapped?()
    }
}
