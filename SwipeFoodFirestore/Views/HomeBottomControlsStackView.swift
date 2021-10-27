//
//  HomeBottomControlsStackView.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 27.10.21.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    override init(frame: CGRect) {
        super .init(frame: frame)
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true

        let subViews = [UIImage(named: "refresh_circle"), .init(named: "dismiss_circle"), .init(named: "super_like_circle"), .init(named: "like_circle"), .init(named: "boost_circle")].map { img -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        subViews.forEach { v in
            addArrangedSubview(v)
        }
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
