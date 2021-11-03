//
//  TopNavigationStackView.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 27.10.21.
//

import UIKit

class TopNavigationStackView: UIStackView {

    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let AppIconImage = UIImageView(image: UIImage(named: "app_icon"))
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        AppIconImage.contentMode = .scaleAspectFit
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        settingsButton.setImage(UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal), for: .normal)
        [settingsButton, UIView(), AppIconImage, UIView(), messageButton].forEach { v in
            addArrangedSubview(v)
        }
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
