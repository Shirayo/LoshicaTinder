//
//  CardView.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 27.10.21.
//

import UIKit

class CardView: UIView {

    fileprivate let border = 150
    fileprivate let rightTapView = UIView()
    fileprivate let leftTapView = UIView()
    fileprivate let imageView = UIImageView(image: UIImage(named: "pizza"))
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    fileprivate let barStackView = UIStackView()
    fileprivate var imageIndex = 0
    
    var cardViewModel: CardViewModel! {
        didSet {
            //setting to [0] will crash app if imageNames .count == 0
            let imageName = cardViewModel.imageNames.first ?? ""
            setImage(from: imageName)
            informationLabel.attributedText = cardViewModel.attibuterdText
            informationLabel.textAlignment = cardViewModel.textAligment
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = UIColor(white: 0, alpha: 0.2)
                barView.layer.cornerRadius = 2
                barStackView.addArrangedSubview(barView)
            }
            barStackView.arrangedSubviews.first?.backgroundColor = .white
        }
    }
    
    //MARK: override functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(rightTapView)
        addSubview(leftTapView)
        
        setupLayout()
        
        let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRightTap))
        let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLeftTap))

        rightTapView.backgroundColor = .clear
        leftTapView.addGestureRecognizer(leftTapGesture)
        rightTapView.addGestureRecognizer(rightTapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)

    }
    
    override func layoutSubviews() {
        gradientLayer.frame = layer.frame
        rightTapView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: frame.width / 2, bottom: 0, right: 0))
        leftTapView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: frame.width / 2))
    }
    
    //MARK: setup components
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperView()
        
        setupGradientLayer()

        addSubview(informationLabel)
        informationLabel.numberOfLines = 0
        informationLabel.textColor = .white
        informationLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        setupBarsStackView()
    }
    
    
    fileprivate func setupBarsStackView() {
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        
    }
    
    func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        gradientLayer.frame = layer.frame
        layer.addSublayer(gradientLayer)
    }

    
    func setImage(from image: String) {
        imageView.image = UIImage(named: image)
    }
    
    //MARK: objc functions
    
    @objc fileprivate func handleRightTap() {
        if imageIndex + 1 > cardViewModel.imageNames.count {
            return
        } else {
            barStackView.arrangedSubviews[imageIndex].backgroundColor = UIColor(white: 0, alpha: 0.2)
            imageIndex += 1
            barStackView.arrangedSubviews[imageIndex].backgroundColor = .white
            setImage(from: cardViewModel.imageNames[imageIndex])
        }
    }
    
    @objc fileprivate func handleLeftTap() {
        if imageIndex - 1 < 0  {
            return
        } else {
            barStackView.arrangedSubviews[imageIndex].backgroundColor = UIColor(white: 0, alpha: 0.2)
            imageIndex -= 1
            barStackView.arrangedSubviews[imageIndex].backgroundColor = .white
            setImage(from: cardViewModel.imageNames[imageIndex])
        }
    }
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
//        case .began:
//            superview?.subviews.forEach({ subview in
//                subview.layer.removeAllAnimations()
//            })
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
