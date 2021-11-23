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

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomControlsStackView()
    var cardViewModels = [CardViewModel]()
    var user: User?
    var lastUser: User?
    var topCardView: CardView?

    //MARK: override functions
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let loginController = LoginController()
            
            loginController.delegate = self
            let navController = UINavigationController(rootViewController: loginController)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupFireStoreUserCards()
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)

        fetchCurrentUser()
    }
    
    //MARK: fetch functions
    
    fileprivate func fetchCurrentUser() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        cardsDeckView.subviews.forEach({$0.removeFromSuperview()})
        Firestore.firestore().collection("users").document(userUid).getDocument { docSnapshot, error in
            if let err = error {
                print(err)
                return
            }
            guard let dictionary = docSnapshot?.data() else { return }
            self.user = User(from: dictionary)
            print("found user")
            self.fetchUsersFromFireStore()
        }
    }
    
    fileprivate func fetchUsersFromFireStore() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading users"
        hud.show(in: self.view)
        let minAge = user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        topCardView = nil
        
        let query = Firestore.firestore().collection("users")
            .whereField("age", isLessThanOrEqualTo: maxAge)
            .whereField("age", isGreaterThanOrEqualTo: minAge)
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
            
            //linked list
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ documentSnapshot in
                let userDictionary = documentSnapshot.data()
                let user = User(from: userDictionary)
                if user.uid != self.user?.uid {
                    self.cardViewModels.append(user.toCardViewModel())
                    self.lastUser = user
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }
    
    //MARK: setup functions
    
    fileprivate func setupCardFromUser(user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperView()
        return cardView
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

    //MARK: delegate functions
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        userDetailsController.modalPresentationStyle = .fullScreen
        userDetailsController.cardViewModel = cardViewModel
        self.present(userDetailsController, animated: true)
    }
    
    func didSavedSettings() {
        print("did saved Setting")
        fetchCurrentUser()
    }
    
    func didFinishLoggingIn() {
        print("didFinishLoggingIn")
        fetchCurrentUser()
    }
    
    func didRemoveCard() {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    //MARK: handle functions
    
    @objc func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
        
    @objc fileprivate func handleRefresh() {
        fetchUsersFromFireStore()
    }
    
    @objc fileprivate func handleLike() {
        performSwipeAnimation(translation: 700, angle: 15)
    }
    
    @objc fileprivate func handleDislike() {
        performSwipeAnimation(translation: -700, angle: -15)
    }
    
    fileprivate func performSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = 0.3
        translationAnimation.fillMode = .forwards
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = 1
        
        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            self.topCardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")

        CATransaction.commit()
       
    }
    
}



