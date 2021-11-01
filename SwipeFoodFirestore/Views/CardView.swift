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
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .red
        addSubview(imageView)
        imageView.fillSuperView()
        clipsToBounds = true
        layer.cornerRadius = 10
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        
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
        UIView.animate(withDuration: 0.75 , delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut) {
            if shouldDismissCard {
                if gesture.translation(in: nil).x > 0 {
                    self.transform = CGAffineTransform(translationX: 1000, y: 0)
                } else {
                    self.transform = CGAffineTransform(translationX: -1000, y: 0)
                }
            } else {
                self.transform = .identity
            }
        } completion: { (_) in
            print("completed animation")
            self.transform = .identity
            self.frame = CGRect(x: 0, y: 0,
                                width: self.superview!.frame.width,
                                height: self.superview!.frame.height
            )
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
