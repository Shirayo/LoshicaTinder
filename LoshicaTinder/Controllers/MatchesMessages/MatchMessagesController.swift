//
//  MatchMessagesController.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 26.11.21.
//

import UIKit
import Firebase
import FirebaseFirestore
import LBTATools

class RecentMessageCell: LBTAListCell<RecentMessage> {
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "nikita1"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "USERNAME TEST"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample message"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 2
        return label
    }()
    
    override var item: RecentMessage! {
        didSet {
            usernameLabel.text = item.name
            messageTextLabel.text = item.text
            userProfileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }

    override func setupViews() {
        super.setupViews()
        userProfileImageView.layer.cornerRadius = 90 / 2
        userProfileImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        userProfileImageView.clipsToBounds = true

        let vStack = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel])
        vStack.axis = .vertical
        vStack.spacing = 2
        let hstack = UIStackView(arrangedSubviews: [userProfileImageView, vStack])
        hstack.axis = .horizontal
        hstack.spacing = 20
        addSubview(hstack)
        hstack.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        hstack.alignment = .center
        addSeparatorView(leadingAnchor:  usernameLabel.leadingAnchor)
    }
    
}

class MatchMessagesController: LBTAListHeaderController<RecentMessageCell, RecentMessage, MatchesHeaderView> , UICollectionViewDelegateFlowLayout, MatchesHorizontalControllerDelegate {

    let customNavBar = MatchesTopNavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRecentMessages()
        collectionView.backgroundColor = .white
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 140
        collectionView.scrollIndicatorInsets.top = 140
        view.addSubview(customNavBar)
        customNavBar.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .zero, size: .init(width: 0, height: 140))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        let navTopCover = UIView()
        navTopCover.backgroundColor = .white
        view.addSubview(navTopCover)
        navTopCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    override func setupHeader(_ header: MatchesHeaderView) {
        header.matchesHorizontalController.delegate = self
    }
    
    fileprivate func fetchRecentMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUserId).collection("recent_messages").order(by: "timestamp", descending: true).addSnapshotListener { querySnapshot, error in
            if let err = error {
                print(err)
                return
            }
            
            var recentMessages = [RecentMessage]()
            
            querySnapshot?.documents.forEach({ documentSnapshot in
                let data = documentSnapshot.data()
                recentMessages.append(.init(from: data))
            })
            self.items = recentMessages
        }
    }
    
    //MARK: datasource/delegate functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    func didSelectItem(match: Match) {
        let chatLogControler = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogControler, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatLogControler = ChatLogController(match: Match(from: items[indexPath.row]))
        navigationController?.pushViewController(chatLogControler, animated: true)
    }
    //MARK: handle functions
    
    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
}
