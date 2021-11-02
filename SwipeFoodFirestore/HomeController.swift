//
//  ViewController.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 26.10.21.
//

import UIKit

class HomeController: UIViewController {

    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()

    let users = [
        User(name: "pizza", age: 18, profession: "tasty peperony", imageName: "pizza"),
        User(name: "donut", age: 23, profession: "yummy chocolate", imageName: "donut")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCards()
        
    }
    
    //MARK: FilePripate
    
    fileprivate func setupCards() {
        users.forEach { (user) in
            let cardView = CardView(frame: .zero)
            cardView.setImage(from: user.imageName)
            
            var information = NSMutableAttributedString(string: user.name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
            information.append(NSAttributedString(string: "  \(user.age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)]))
            information.append(NSAttributedString(string: "\n\(user.profession)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)]))
            cardView.informationLabel.textColor = .white
            cardView.informationLabel.attributedText = information
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperView()
        }
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
}



