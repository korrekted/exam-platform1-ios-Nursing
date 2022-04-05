//
//  Spinner.swift
//  Nursing
//
//  Created by Андрей Чернышев on 04.04.2022.
//

import UIKit

final class Spinner: UIView {
    private let animationKey = "spinner_rotation_key"
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame.size = size
        view.image = UIImage(named: "Spinner")
        view.contentMode = .scaleAspectFit
        addSubview(view)
        return view
    }()
    
    private let size: CGSize
    
    init(size: CGSize) {
        self.size = size
        
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension Spinner {
    func startAnimating() {
        isHidden = false
        
        guard imageView.layer.animation(forKey: animationKey) == nil else {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = Float.pi * 2
        animation.fromValue = 0
        animation.isCumulative = true
        animation.repeatCount = HUGE
        animation.duration = 2.5
        
        imageView.layer.add(animation, forKey: animationKey)
    }
    
    func stopAnimating() {
        isHidden = true
        
        imageView.layer.removeAnimation(forKey: animationKey)
    }
}

// MARK: Private
private extension Spinner {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}
