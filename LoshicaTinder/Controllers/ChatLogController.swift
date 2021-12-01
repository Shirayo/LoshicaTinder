//
//  ChatLogController.swift
//  LoshicaTinder
//
//  Created by Shirayo on 30.11.2021.
//

import Foundation
import UIKit

struct Message {
    let text: String
    let isFromCurrentUser: Bool
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
    var messages: [Message] = [
        Message(text: "hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus hello from Vasily Shirayo Mordus ", isFromCurrentUser: true),
        Message(text: "hello from Vasily Shirayo Mordus", isFromCurrentUser: false),
        Message(text: "hello", isFromCurrentUser: true)
    ]
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        super.init(collectionViewLayout: UICollectionViewFlowLayout() )
    }
        
    lazy var redView: UIView = {
        return CustomInputAccessView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
    }()
    
    override var inputAccessoryView: UIView? {
        get {
           return redView
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.keyboardDismissMode = .interactive
        setupUI()
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
