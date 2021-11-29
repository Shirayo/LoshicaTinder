//
//  MatchesTopNavigationBar.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 29.11.21.
//

import Foundation
import UIKit

class MatchesTopNavigationBar: UIView {
    
    let backButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let iconImageView = UIImageView(image: UIImage(named: "top_messages_icon")?.withRenderingMode(.alwaysTemplate))
        iconImageView.tintColor = UIColor.orange
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
        let messagesLabel = UILabel(text: "Messages", font: UIFont.systemFont(ofSize: 20), textColor: .orange, textAlignment: .center, numberOfLines: 0)
        let feedLabel = UILabel(text: "Feed", font: UIFont.systemFont(ofSize: 20), textColor: .gray, textAlignment: .center, numberOfLines: 0)
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 8
        
        let topStackView = UIStackView(arrangedSubviews: [messagesLabel, feedLabel])
        topStackView.distribution = .fillEqually
        topStackView.axis = .horizontal
        
        let overallStackView = UIStackView(arrangedSubviews: [iconImageView, topStackView])
        overallStackView.axis = .vertical
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        backButton.setImage(UIImage(named: "app_icon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = .lightGray
        
        addSubview(overallStackView)
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 16, bottom: 0, right: 0), size: .init(width: 34, height: 34))
        overallStackView.fillSuperView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
