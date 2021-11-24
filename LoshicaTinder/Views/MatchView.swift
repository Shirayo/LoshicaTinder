//
//  MatchView.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 24.11.21.
//

import UIKit

class MatchView: UIView {

    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let currentUserimageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "saveliy1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    let cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "saveliy2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBlurView()
        setupLayout()
    }
    
    fileprivate func setBlurView() {
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        addSubview(visualEffectView)
        visualEffectView.fillSuperView()
        alpha = 0
        UIView.animate(withDuration: 0.4) {
            self .alpha = 1
        }
      
    }
    
    fileprivate func setupLayout() {
        addSubview(currentUserimageView)
        addSubview(cardUserImageView)

        currentUserimageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: 140, height: 140))
        currentUserimageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currentUserimageView.layer.cornerRadius = 140 / 2
        
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 140, height: 140))
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardUserImageView.layer.cornerRadius = 140 / 2
    }
    
    @objc fileprivate func handleDismiss() {
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
