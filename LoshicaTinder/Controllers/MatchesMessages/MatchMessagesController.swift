//
//  MatchMessagesController.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 26.11.21.
//

import UIKit

class MatchMessagesController: UICollectionViewController {

    let customNavBar: UIView = {
        let navbar = UIView()
        navbar.backgroundColor = .white
        
        let messagesLabel = UILabel(text: "Messages", font: UIFont.systemFont(ofSize: 20), textColor: .black, textAlignment: .center, numberOfLines: 0)
        let feedLabel = UILabel(text: "Feed", font: UIFont.systemFont(ofSize: 20), textColor: .black, textAlignment: .center, numberOfLines: 0)
        let topStackView = UIStackView(arrangedSubviews: [messagesLabel, feedLabel])
        topStackView.distribution = .fillEqually
        topStackView.axis = .horizontal
        topStackView.backgroundColor = .red
        let iconImageView = UIImageView(image: UIImage(named: "top_right_messages"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView, topStackView])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        navbar.addSubview(stackView)
        stackView.fillSuperView()
        
        return navbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .zero, size: .init(width: 0, height: 140))
        customNavBar.layer.shadowColor = UIColor.lightGray.cgColor
        customNavBar.layer.shadowOpacity = 0.2
        customNavBar.layer.shadowOffset = CGSize(width: 0, height: 10)
        customNavBar.layer.shadowRadius = 8
    }

    
    
}
