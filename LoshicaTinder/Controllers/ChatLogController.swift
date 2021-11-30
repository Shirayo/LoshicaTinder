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
}

class MessageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MessagesNavBar(match: self.match)
    fileprivate let navBarHeight: CGFloat = 100
    var messages = [Message]()
    
    fileprivate let match: Match

    init(match: Match) {
        self.match = match
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customNavBar)
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: "messageCell")
        customNavBar.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .zero, size: .init(width: 0, height: navBarHeight))
        collectionView.contentInset.top = navBarHeight
    }
    
    //MARK: datasource&delegate
 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as! MessageCell
//        cell.matchUserProfile = users[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 80, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
