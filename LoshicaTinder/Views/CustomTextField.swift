//
//  CustomTextField.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 4.11.21.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    
    let padding: CGFloat
    var height: CGFloat
    
    init(padding: CGFloat, height: CGFloat) {
        self.padding = padding
        self.height = height
        super.init(frame: .zero)
        layer.cornerRadius = height / 2
        backgroundColor = .white
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
   
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
