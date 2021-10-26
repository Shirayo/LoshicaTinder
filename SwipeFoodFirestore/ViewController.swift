//
//  ViewController.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 26.10.21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello world")
        
        let subViews = [UIColor.lightGray, UIColor.gray, UIColor.darkGray].map { color -> UIView in
            let v = UIView()
            v.backgroundColor = color
            return v
        }
        let topStackView = UIStackView(arrangedSubviews: subViews)
        topStackView.distribution = .fillEqually
        topStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        let blueView = UIView()
        blueView.backgroundColor = .blue
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        yellowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [topStackView, blueView, yellowView])
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.fillSuperView()
    }

}



