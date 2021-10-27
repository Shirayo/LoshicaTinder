//
//  ViewController.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 26.10.21.
//

import UIKit

class ViewController: UIViewController {

    let topStackView = TopNavigationStackView()
    let blueView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView.backgroundColor = .blue
        setupLayout()
    }
    
    //MARK: FilePripate
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, blueView, buttonsStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }
    
}



