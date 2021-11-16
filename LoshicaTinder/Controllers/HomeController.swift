//
//  ViewController.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 26.10.21.
//

import UIKit
import FirebaseFirestore
import Firebase
import JGProgressHUD

protocol SettingsControllerDelegate {
    func didSavedSettings()
}

class HomeController: UIViewController, SettingsControllerDelegate {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    
    var cardViewModels = [CardViewModel]()
    let settingsController = SettingsController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        settingsController.delegate = self
        setupLayout()
        setupFireStoreUserCards()
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        fetchCurrentUser()
    }
    
    fileprivate func fetchCurrentUser() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userUid).getDocument { docSnapshot, error in
            if let err = error {
                print(err)
                return
            }
            guard let dictionary = docSnapshot?.data() else { return }
            self.user = User(from: dictionary)
            self.fetchUsersFromFireStore()
        }
    }
    
    var user: User?
    var lastUser: User?
    
    func didSavedSettings() {
        print("did saved Setting")
        fetchCurrentUser()
    }
    
    fileprivate func fetchUsersFromFireStore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading users"
        hud.show(in: self.view)
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else { return }
//        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastUser?.uid ?? ""]).limit(to: 2)
        let query = Firestore.firestore().collection("users").whereField("age", isLessThanOrEqualTo: maxAge).whereField("age", isGreaterThanOrEqualTo: minAge)
        query.getDocuments { snapshot, error in
            if snapshot?.documents.isEmpty == true {
                print("heh")
                hud.textLabel.text = "empty"
                hud.dismiss(afterDelay: 1.5)
            } else {
                hud.dismiss(animated: true)

            }
            if let err = error {
                print(err)
                return
            }
            snapshot?.documents.forEach({ documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(from: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastUser = user
                self.setupCardFromUser(user: user)
            })
        }
    }
    
    fileprivate func setupCardFromUser(user: User) {
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperView()
    }
    
    
    @objc func handleSettings() {
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    //MARK: Fileprivate
    
    @objc fileprivate func handleRefresh() {
        cardViewModels = []
        fetchUsersFromFireStore()
    }
    
    fileprivate func setupFireStoreUserCards() {
        cardViewModels.forEach { cardVM in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperView()
        }
    }
    
    fileprivate func setupLayout() {
        let overallStackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        overallStackView.axis = .vertical
        view.addSubview(overallStackView)
        overallStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 8, bottom: 0, right: 8)
        overallStackView.bringSubviewToFront(cardsDeckView)
    }
    
}



