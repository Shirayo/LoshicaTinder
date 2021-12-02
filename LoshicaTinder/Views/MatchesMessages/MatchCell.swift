//
//  MatchCell.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 2.12.21.
//

import Foundation
import LBTATools
import UIKit

class MatchCell: LBTAListCell<Match> {
    
    let profileImageView = UIImageView(image: UIImage(named: "nikita3"))
    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14), textColor: .black, textAlignment: .center, numberOfLines: 2)
    
//    var matchUserProfile: Match! {
//        didSet {
//            guard let imageUrl = URL(string: matchUserProfile.profileImageUrl) else { return }
//            profileImageView.sd_setImage(with: imageUrl)
//            usernameLabel.text = matchUserProfile.name
//        }
//    }
    
    override var item: Match! {
        didSet {
            usernameLabel.text = item.name
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        let profileStackView = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        profileStackView.axis = .vertical
        
        addSubview(profileStackView)
        profileStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
    }
}
