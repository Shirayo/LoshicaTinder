//
//  ChatLogController.swift
//  LoshicaTinder
//
//  Created by Shirayo on 30.11.2021.
//

import Foundation
import UIKit
import LBTATools
import Firebase
import FirebaseFirestore

struct Message {
    let text, fromUid, toUid: String
    let timestamp: Timestamp
    let isFromCurrentUser: Bool
    
    init(from dict: [String: Any]) {
        self.text = dict["text"] as? String ?? ""
        self.fromUid = dict["fromUid"] as? String ?? ""
        self.toUid = dict["toUid"] as? String ?? ""
        self.timestamp = dict["text"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = Auth.auth().currentUser?.uid == self.fromUid
    }
}

class MessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }()
    
    let bubbleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 15
        return view
    }()
    
    var item: Message! {
        didSet {
            self.textView.text = item.text
            if item.isFromCurrentUser {
                anchoredConstraints.trailing?.isActive = true
                anchoredConstraints.leading?.isActive = false
                bubbleContainerView.backgroundColor = UIColor(named: "lightBlueColor")
            } else {
                anchoredConstraints.trailing?.isActive = false
                anchoredConstraints.leading?.isActive = true
                bubbleContainerView.backgroundColor = UIColor(named: "lightGrayColor")
            }
        }
    }
    
    
    var anchoredConstraints: AnchoredConstraints!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bubbleContainerView)
        anchoredConstraints = bubbleContainerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.isActive = false
        anchoredConstraints.trailing?.constant = -20
        
        bubbleContainerView.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        bubbleContainerView.addSubview(textView)
        textView.anchor(top: bubbleContainerView.topAnchor, leading: bubbleContainerView.leadingAnchor, bottom: bubbleContainerView.bottomAnchor, trailing: bubbleContainerView.trailingAnchor, padding: .init(top: 4, left: 8, bottom: 4, right: 8))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MessagesNavBar(match: self.match)
    fileprivate let navBarHeight: CGFloat = 100
    fileprivate let match: Match
    fileprivate var messages = [Message]()
    fileprivate lazy var customInputView: CustomInputAccessView = {
        let civ = CustomInputAccessView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
        civ.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return civ
    }()
    
    var currentUser: Match?

    
    init(match: Match) {
        self.match = match
        super.init(collectionViewLayout: UICollectionViewFlowLayout() )
    }
    
    override var inputAccessoryView: UIView? {
        get {
           return customInputView
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        collectionView.keyboardDismissMode = .interactive
        
        
        guard let currentUsedUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(currentUsedUid).getDocument { documentSnapshot, error in
            if let err = error {
                print(err)
                return
            }
            guard let data = documentSnapshot?.data() else { return }
            self.currentUser = Match(fromUser: data)
        }
        
        setupUI()
        fetchMessages()
    }
    
    @objc fileprivate func handleKeyboardShow() {
        self.collectionView.scrollToItem(at: [0, messages.count - 1], at: .bottom, animated: true)
    }
    
    fileprivate func fetchMessages() {
        messages = []
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        let query = Firestore.firestore().collection("matches_messages").document(currentUserUid).collection(match.uid).order(by: "timestamp")
        
        query.addSnapshotListener { querySnapshot, error in
            if let err = error {
                print(err)
                return
            }
            
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dict = change.document.data()
                    self.messages.append(.init(from: dict))
                }
                                                   
                
            })
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)

        }

    }
    
    @objc func handleSend() {
        guard let textToSend = customInputView.textView.text else { return }
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        if textToSend != "" {
            let data: [String: Any] = ["text": textToSend, "fromUid": currentUserUid, "toUid": match.uid, "timestamp": Timestamp(date: Date())]
            
            let fromCollection = Firestore.firestore().collection("matches_messages").document(currentUserUid).collection(match.uid)
            fromCollection.addDocument(data: data) { error in
                if let err = error {
                    print(err)
                    return
                }
                print("saved to firestore")
                self.customInputView.textView.text = ""
                self.customInputView.placeHolderLabel.isHidden = false
            }
            
            let toCollection = Firestore.firestore().collection("matches_messages").document(match.uid).collection(currentUserUid)
            toCollection.addDocument(data: data) { error in
                if let err = error {
                    print(err)
                    return
                }            
            }
            
            let recentMessageData: [String: Any] = ["name": match.name, "text": textToSend, "uid": match.uid, "imageUrl": match.profileImageUrl, "timestamp": Timestamp(date: Date())]
            let recentMessagePathFrom = Firestore.firestore().collection("matches_messages").document(currentUserUid).collection("recent_messages").document(match.uid)
            recentMessagePathFrom.setData(recentMessageData) { error in
                if let err = error {
                    print(err)
                    return
                }
            }
            
            let recentMessageData2: [String: Any] = ["name": currentUser?.name, "text": textToSend, "uid": currentUserUid, "imageUrl": currentUser?.profileImageUrl, "timestamp": Timestamp(date: Date())]

            
            let recentMessagePathTo = Firestore.firestore().collection("matches_messages").document(match.uid).collection("recent_messages").document(currentUserUid)
            recentMessagePathTo.setData(recentMessageData2) { error in
                if let err = error {
                    print(err)
                    return
                }
            }
        }
    }


    fileprivate func setupUI() {
        view.addSubview(customNavBar)
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "messageCell")
        customNavBar.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .zero, size: .init(width: 0, height: navBarHeight))
        collectionView.contentInset.top = navBarHeight
        collectionView.scrollIndicatorInsets.top = navBarHeight
        let navTopCover = UIView()
        navTopCover.backgroundColor = .white
        view.addSubview(navTopCover)
        navTopCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    //MARK: datasource&delegate
 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! MessageCell
        cell.item = messages[indexPath.row]
//        cell.matchUserProfile = users[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //estimated sizing
        let estimatedSizeCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        estimatedSizeCell.item = self.messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
