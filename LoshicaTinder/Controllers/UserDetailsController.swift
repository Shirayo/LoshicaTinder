//
//  UserDetailsController.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 17.11.21.
//

import UIKit

class UserDetailsController: UIViewController, UIScrollViewDelegate {

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let label: UILabel = {
       let label = UILabel()
        label.text = "TEST TEST"
        label.numberOfLines = 0
        return label
        
    }()
    
    let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "back_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleTapDismiss), for: .touchUpInside)
        return btn
    }()
    
    var cardViewModel : CardViewModel? {
        didSet {
            label.attributedText = cardViewModel?.attibuterdText
            swipingPhotosController.cardViewModel = cardViewModel
        }
    }
    
    let swipingPhotosController = SwipingPhotosController()
    
    lazy var dislikeButton = createButton(image: UIImage(named: "dismiss_circle")!, selector: #selector(handleDislike))
    lazy var superLikeButton = createButton(image: UIImage(named: "super_like_circle")!, selector: #selector(handleDislike))
    lazy var likeButton = createButton(image: UIImage(named: "like_circle")!, selector: #selector(handleDislike))

    
    func createButton(image: UIImage, selector: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        btn.imageView?.contentMode = .scaleToFill
        return btn
    }
    
    
    //MARK: override functions
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let swipingView = swipingPhotosController.view!
        swipingView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupVisualBlur()
        setupBottomControls()
    }
    
    //MARK: setup functions
    
    fileprivate func setupLayout() {
        view.addSubview(scrollView)
        scrollView.fillSuperView()
        
        let imageView = swipingPhotosController.view!
        
        scrollView.addSubview(imageView)
        
        scrollView.addSubview(label)
        label.anchor(top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
        scrollView.addSubview(backButton)
        backButton.anchor(top: imageView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: -22, left: 0, bottom: 0, right: 32), size: .init(width: 44, height: 44))
    }
    
    fileprivate func setupVisualBlur() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupBottomControls() {
        let bottomStackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        view.addSubview(bottomStackView)
        bottomStackView.distribution = .equalSpacing
        bottomStackView.spacing = -32
        bottomStackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 80))
        bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    //MARK: handle functions
    
    @objc fileprivate func handleDislike() {
        print("dislike")
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let yOffset = -scrollView.contentOffset.y

        var width =  self.view.frame.width + yOffset
        width = max(self.view.frame.width, width)

        var height = self.view.frame.height / 2 + yOffset
        height = max(self.view.frame.height / 2, height)

        let swipingView = swipingPhotosController.view!
        swipingView.frame = CGRect(x: min(0, -yOffset / 2), y: min(0, -yOffset), width: width , height: height)
    }
    
}
