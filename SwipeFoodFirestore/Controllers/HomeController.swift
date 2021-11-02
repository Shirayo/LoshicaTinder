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
    
    let cardViewModels = [
        User(name: "Pizza", age: 18, profession: "tasty peperony", imageName: "pizza").toCardView(),
        User(name: "Donut", age: 23, profession: "yummy chocolate", imageName: "donut").toCardView()
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCards()
        
    }
    
    //MARK: FilePripate
    
    fileprivate func setupCards() {
        cardViewModels.forEach { cardVM in
            let cardView = CardView(frame: .zero)
            cardView.setImage(from: cardVM.imageName)
            cardView.informationLabel.attributedText = cardVM.attibuterdText
            cardView.informationLabel.textAlignment = cardVM.textAligment
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



