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
    
    let cardViewModels: [CardViewModel] = {
        let produsers = [
            Advertiser(title: "Hello world", brandName: "Shirayo inc.", posterPhotoName: "advertising"),
            User(name: "Pizza", age: 18, profession: "tasty peperony", imageName: "pizza"),
            User(name: "Donut", age: 23, profession: "yummy chocolate", imageName: "donut"),
        ] as [ProdusesCardViewModel]
        let viewModels = produsers.map {return $0.toCardViewModel()}
        return viewModels
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCards()
        
    }
    
    //MARK: FilePripate
    
    fileprivate func setupCards() {
        cardViewModels.forEach { cardVM in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
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



