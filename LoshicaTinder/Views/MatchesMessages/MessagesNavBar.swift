//
//  MessagesNavBar.swift
//  LoshicaTinder
//
//  Created by Shirayo on 30.11.2021.
//

import Foundation
import UIKit

class MessagesNavBar: UIView {
    
    fileprivate let userProfileImageView: UIImageView = {
        let imageVIew = UIImageView(image: UIImage(named: "nikita1"))
        imageVIew.contentMode = .scaleAspectFill
        return imageVIew
    }()
    
    fileprivate let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "sample text"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let pinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "flag")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        super.init(frame: .zero)
        
        backgroundColor = .white
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 8
        
        userNameLabel.text = match.name
        
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        
        let imageHeight: CGFloat = 72
        userProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        userProfileImageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: imageHeight).isActive = true
        userProfileImageView.layer.cornerRadius = imageHeight / 2
        userProfileImageView.clipsToBounds = true
        
        let vStack = UIStackView(arrangedSubviews: [userProfileImageView, userNameLabel])
        vStack.axis = .vertical
        vStack.alignment = .center
       
        let overallStackView = UIStackView(arrangedSubviews: [backButton, vStack, pinButton])
        addSubview(overallStackView)
        overallStackView.fillSuperView()
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        overallStackView.axis = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
