//
//  CardView.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 27.10.21.
//

import UIKit

class CardView: UIView {

    fileprivate let imageView = UIImageView(image: UIImage(named: "pizza"))
    fileprivate let border = 150
    var informationLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .red
        addSubview(imageView)
        imageView.fillSuperView()
        clipsToBounds = true
        layer.cornerRadius = 1
        imageView.addSubview(informationLabel)
        informationLabel.numberOfLines = 0
        informationLabel.textColor = .white
        informationLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
    }
    
    func setImage(from image: String) {
        imageView.image = UIImage(named: image)
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended :
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 15
        let angle = degrees * .pi / 180
        let rotationTransformations = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationTransformations.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let shouldDismissCard = Int(abs(gesture.translation(in: nil).x)) > border
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        
        UIView.animate(withDuration: 0.4 , delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            if shouldDismissCard {
                self.transform = CGAffineTransform(translationX: 600 * translationDirection, y: 0)
            } else {
                self.transform = .identity
            }
        } completion: { (_) in
            print("completed animation")
//            self.transform = .identity
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
