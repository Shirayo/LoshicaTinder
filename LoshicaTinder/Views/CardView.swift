//
//  CardView.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 27.10.21.
//

import UIKit

class CardView: UIView {

    fileprivate let border = 150
    fileprivate let diselectedBarColor = UIColor(white: 0.5, alpha: 1.1)
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
                barView.backgroundColor = diselectedBarColor
                barView.layer.cornerRadius = 2
                barStackView.addArrangedSubview(barView)
            }
            barStackView.arrangedSubviews.first?.backgroundColor = .white
        }
    }
    
    //MARK: override functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(tapGesture)

    }
    
    override func layoutSubviews() {
        gradientLayer.frame = layer.frame
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
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        print(tapLocation.x, shouldAdvanceNextPhoto , imageIndex, cardViewModel.imageNames.count)
        barStackView.arrangedSubviews[imageIndex].backgroundColor = diselectedBarColor
        if shouldAdvanceNextPhoto {
            imageIndex = min(imageIndex + 1, cardViewModel.imageNames.count - 1)
        } else {
            imageIndex = max(imageIndex - 1, 0)
        }
        setImage(from: cardViewModel.imageNames[imageIndex])
        barStackView.arrangedSubviews[imageIndex].backgroundColor = .white

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
