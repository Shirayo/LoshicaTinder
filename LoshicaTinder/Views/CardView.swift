//
//  CardView.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 27.10.21.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    
    func didTapMoreInfo(cardViewModel: CardViewModel)
    func didRemoveCard()
}

class CardView: UIView {

    fileprivate let border = 150
    fileprivate let diselectedBarColor = UIColor(white: 0.5, alpha: 1.1)
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let informationLabel = UILabel()
    fileprivate let barStackView = UIStackView()
    fileprivate let swipingPhotoController = SwipingPhotosController(isCardViewMode: true)
    
    var delegate: CardViewDelegate?
    var nextCardView: CardView?
    
    let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()

    var cardViewModel: CardViewModel! {
        didSet {
            swipingPhotoController.cardViewModel = self.cardViewModel
            
            informationLabel.attributedText = cardViewModel.attibuterdText
            informationLabel.textAlignment = cardViewModel.textAligment
            (0..<cardViewModel.imageUrls.count).forEach { (i) in
                let barView = UIView()
                barView.backgroundColor = diselectedBarColor
                barView.layer.cornerRadius = 2
                barStackView.addArrangedSubview(barView)
            }
            barStackView.arrangedSubviews.first?.backgroundColor = .white
            setupIndexImageObserver()
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
    
    fileprivate func  setupIndexImageObserver() {
        cardViewModel.imageIndexObserver = { [weak self] (index, url) in
            self?.barStackView.arrangedSubviews.forEach { bar in
                bar.backgroundColor = self?.diselectedBarColor
            }
            self?.barStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let swipingPhotosView = swipingPhotoController.view!
        
        addSubview(swipingPhotosView)
        swipingPhotosView.fillSuperView()
        
        setupGradientLayer()

        addSubview(informationLabel)
        informationLabel.numberOfLines = 0
        informationLabel.textColor = .white
        informationLabel.anchor(top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        addSubview(moreInfoButton)
        moreInfoButton.anchor(top: nil, leading: nil, bottom: self.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    
    fileprivate func setupBarStackView() {
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
    
    //MARK: handle functions
    
    @objc fileprivate func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: cardViewModel)
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        
        
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
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
                self.delegate?.didRemoveCard()
            } else {
                self.transform = .identity
            }
        } completion: { (_) in
            print("completed animation")
        }
    }
    
    //MARK: required
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
