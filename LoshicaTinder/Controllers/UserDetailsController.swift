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
    
    let image: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "nikita1")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let label: UILabel = {
       let label = UILabel()
        label.text = "TEST TEST"
        label.numberOfLines = 0
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.fillSuperView()
        
        scrollView.addSubview(image)
        image.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        scrollView.addSubview(label)
        label.anchor(top: image.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = -scrollView.contentOffset.y
        var width =  self.view.frame.width + yOffset
        width = max(self.view.frame.width, width)
        image.frame = CGRect(x: min(0,-yOffset / 2), y: min(0, -yOffset), width: width , height: width)
    }
    
    @objc fileprivate func handleTapDismiss() {
        self.dismiss(animated: true)
    }
    
    
}
