//
//  MatchView.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 24.11.21.
//

import UIKit

class MatchView: UIView {

    fileprivate let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate let currentUserimageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "saveliy1"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "saveliy2"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    fileprivate let itsaMatchImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "it_is_a_match"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate let matchLabel: UILabel = {
       let label = UILabel()
        label.text = "you and ___ have liked each other"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
        
    fileprivate let sendMessageButton: UIButton = {
        let btn = SendMessageButton(type: .system)
        btn.setTitle("SEND MESSAGE", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    fileprivate let keepSwipingButton: UIButton = {
        let btn = KeepSwipingButton(type: .system)
        btn.setTitle("Keep Swiping", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBlurView()
        setupLayout()
        setupAnimations()
    }
    
    fileprivate func setupAnimations() {
        //init starting positions
        let degrees: CGFloat = 30
        let angle: CGFloat = degrees * .pi / 180
        currentUserimageView.transform = CGAffineTransform(translationX: 200, y: 0).rotated(by: angle)
        cardUserImageView.transform = CGAffineTransform(translationX: -200, y: 0).rotated(by: -angle)
        
        sendMessageButton.transform = CGAffineTransform(translationX: 400, y: 0)
        keepSwipingButton.transform = CGAffineTransform(translationX: -400, y: 0)
        
        UIView.animate(withDuration: 0.5  , delay: 0, options: .curveEaseOut) {
            self.currentUserimageView.transform = CGAffineTransform(translationX: 0, y: 0).rotated(by: angle)
            self.cardUserImageView.transform = CGAffineTransform(translationX: 0, y: 0).rotated(by: -angle)
        } completion: { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.currentUserimageView.transform = CGAffineTransform.init(rotationAngle: 0)
                self.cardUserImageView.transform = CGAffineTransform.init(rotationAngle: 0)
            }
        }
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.sendMessageButton.transform = CGAffineTransform(translationX: 0, y: 0)
            self.keepSwipingButton.transform = CGAffineTransform(translationX: 0, y: 0)
        }


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
        addSubview(matchLabel)
        addSubview(itsaMatchImageView)
        addSubview(sendMessageButton)
        addSubview(keepSwipingButton)
        
        currentUserimageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 8), size: .init(width: 140, height: 140))
        currentUserimageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currentUserimageView.layer.cornerRadius = 140 / 2
        
        cardUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 8, bottom: 0, right: 0), size: .init(width: 140, height: 140))
        cardUserImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cardUserImageView.layer.cornerRadius = 140 / 2
        
        matchLabel.anchor(top: nil, leading: leadingAnchor, bottom: currentUserimageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 32, right: 0), size: .init(width: 0, height: 50))
        
        itsaMatchImageView.anchor(top: nil, leading: nil, bottom: matchLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        itsaMatchImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentUserimageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 50))
         
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 48, bottom: 0, right: 48), size: .init(width: 0, height: 50 ))
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
