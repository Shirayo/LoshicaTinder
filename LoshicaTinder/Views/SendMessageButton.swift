//
//  SendMessageButton.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 25.11.21.
//

import UIKit

class SendMessageButton: UIButton {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = UIColor.red.cgColor
        let rightColor = UIColor.orange.cgColor
        gradientLayer.colors = [leftColor, rightColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = rect
        
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
