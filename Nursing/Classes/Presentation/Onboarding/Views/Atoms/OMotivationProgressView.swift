//
//  OMotivationProgressView.swift
//  Nursing
//
//  Created by Андрей Чернышев on 23.02.2022.
//

import UIKit

final class OMotivationProgressView: UIView {
    private let lineWidth = 24.scale
    
    private var backgroundShape: CAShapeLayer!
    private var progressShape: CAShapeLayer!
    private var circleShape: CAShapeLayer!
    
    private var progressAnimation: CABasicAnimation!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(progress: CGFloat) {
        var start = progressShape.strokeEnd
        
        if let presentationLayer = progressShape.presentation() {
            if let count = progressShape.animationKeys()?.count, count > 0  {
                start = presentationLayer.strokeEnd
            }
        }
        
        let duration = abs(Double(progress - start)) * 4
        
        progressShape.strokeEnd = progress
        
        progressAnimation.fromValue = start
        progressAnimation.toValue = progress
        progressAnimation.duration = duration
        progressShape.add(progressAnimation, forKey: progressAnimation.keyPath)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateShapes()
        updateCircle()
    }
}

// MARK: Private
private extension OMotivationProgressView {
    func initialize() {
        backgroundShape = CAShapeLayer()
        backgroundShape.lineWidth = lineWidth
        backgroundShape.fillColor = nil
        backgroundShape.strokeColor = Appearance.mainColor.withAlphaComponent(0.2).cgColor
        backgroundShape.lineCap = .round
        layer.addSublayer(backgroundShape)
        
        progressShape = CAShapeLayer()
        progressShape.lineWidth = lineWidth
        progressShape.fillColor = nil
        progressShape.strokeStart = 0.0
        progressShape.strokeColor = Appearance.mainColor.cgColor
        progressShape.strokeEnd = 0.1
        progressShape.lineCap = .round
        layer.addSublayer(progressShape)
        
        circleShape = CAShapeLayer()
        circleShape.lineWidth = 2.scale
        circleShape.fillColor = Appearance.successColor.cgColor
        circleShape.strokeColor = Appearance.backgroundColor.cgColor
        layer.addSublayer(circleShape)
        
        progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
    }
    
    func updateShapes() {
        backgroundShape.frame = bounds
        progressShape.frame = bounds
        
        let rect = bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        backgroundShape.path = pathForShape(rect: rect).cgPath
        progressShape.path = pathForShape(rect: rect).cgPath
        
        progressShape.transform = CATransform3DMakeRotation(CGFloat.pi * 2, 0, 0, 1)
        backgroundShape.transform = CATransform3DMakeRotation(CGFloat.pi * 2, 0, 0, 1)
    }
    
    func pathForShape(rect: CGRect) -> UIBezierPath {
        let spaceDegree = CGFloat(90)
        
        let startAngle = CGFloat(spaceDegree * .pi / 180) + (0.5 * .pi)
        let endAngle = CGFloat((360 - spaceDegree) * (.pi / 180)) + (0.5 * .pi)
        
        return UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.maxY),
                            radius: rect.size.width / 2,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: true)
    }
    
    func updateCircle() {
        let path = UIBezierPath(ovalIn: CGRect(x: 0,
                                               y: 0,
                                               width: 18.scale,
                                               height: 18.scale))
        
        circleShape.path = path.cgPath
        circleShape.position = CGPoint(x: 28.scale,
                                       y: 35.scale)
    }
}
