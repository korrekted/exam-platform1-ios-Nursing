//
//  BubbleView.swift
//  Nursing
//
//  Created by Виталий Загороднов on 17.02.2022.
//

import UIKit

class BubbleView: UIView {
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: rect.minX + 39.25, y: rect.minY))
        bezierPath.addCurve(to: CGPoint(x: rect.minX + 50.46, y: rect.minY + 12.18), controlPoint1: CGPoint(x: rect.minX + 39.25, y: rect.minY - 0), controlPoint2: CGPoint(x: rect.minX + 44.94, y: rect.minY + 6.17))
        bezierPath.addLine(to: CGPoint(x: rect.maxX - 10.65, y: rect.minY + 12.18))
        bezierPath.addCurve(to: CGPoint(x: rect.maxX, y: rect.minY + 23), controlPoint1: CGPoint(x: rect.maxX - 4.77, y: rect.minY + 12.18), controlPoint2: CGPoint(x: rect.maxX, y: rect.minY + 17.02))
        bezierPath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 9.76))
        bezierPath.addCurve(to: CGPoint(x: rect.maxX - 10.65, y: rect.maxY), controlPoint1: CGPoint(x: rect.maxX, y: rect.maxY - 4.37), controlPoint2: CGPoint(x: rect.maxX - 4.77, y: rect.maxY))
        bezierPath.addLine(to: CGPoint(x: rect.minX + 10.65, y: rect.maxY))
        bezierPath.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY - 9.76), controlPoint1: CGPoint(x: rect.minX + 4.77, y: rect.maxY), controlPoint2: CGPoint(x: rect.minX, y: rect.maxY - 4.37))
        bezierPath.addLine(to: CGPoint(x: rect.minX, y: rect.minY + 23))
        bezierPath.addCurve(to: CGPoint(x: rect.minX + 10.65, y: rect.minY + 12.18), controlPoint1: CGPoint(x: rect.minX, y: rect.minY + 17.57), controlPoint2: CGPoint(x: rect.minX + 5.53, y: rect.minY + 12.96))
        bezierPath.addCurve(to: CGPoint(x: rect.minX + 28.04, y: rect.minY + 12.18), controlPoint1: CGPoint(x: rect.minX + 11.17, y: rect.minY + 12.1), controlPoint2: CGPoint(x: rect.minX + 28.04, y: rect.minY + 12.18))
        bezierPath.addLine(to: CGPoint(x: rect.minX + 39.25, y: rect.minY))
        bezierPath.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = bezierPath.cgPath
        layer.mask = maskLayer
    }
}
