//
//  UILabel.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 26.11.21.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(text: String? = nil, font: UIFont? = UIFont.systemFont(ofSize: 14), textColor: UIColor = .black, textAlignment: NSTextAlignment = .left, numberOfLines: Int = 1) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}
