//
//  Spinner.swift
//  Nursing
//
//  Created by Андрей Чернышев on 04.04.2022.
//

import UIKit

final class Spinner: UIView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame.size = CGSize(width: 40.scale, height: 40.scale)
        view.image = UIImage(named: "Spinner")
        view.contentMode = .scaleAspectFit
        addSubview(view)
        return view
    }()
    
    private lazy var behavior = UIDynamicItemBehavior(items: [imageView])
    private lazy var animator = UIDynamicAnimator(referenceView: self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        guard !animator.behaviors.contains(behavior) else {
            return
        }
        
        behavior.addAngularVelocity(5, for: imageView)
        animator.addBehavior(behavior)
    }
    
    func stopAnimating() {
        isHidden = true
        
        animator.removeAllBehaviors()
    }
}

// MARK: Private
private extension Spinner {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}
