//
//  MatchMessagesController.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 26.11.21.
//

import UIKit
import Firebase
import FirebaseFirestore

struct Match {
    
    let name: String
    let profileImageUrl: String
    let uid: String
    
    init(from dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.profileImageUrl = dict["imageUrl"] as? String ?? ""
        self.uid = dict["uid"] as? String ?? ""
    }
}

class MatchCell: UICollectionViewCell {
    
    let profileImageView = UIImageView(image: UIImage(named: "nikita3"))
    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14), textColor: .black, textAlignment: .center, numberOfLines: 2)
    
    var matchUserProfile: Match! {
        didSet {
            guard let imageUrl = URL(string: matchUserProfile.profileImageUrl) else { return }
            profileImageView.sd_setImage(with: imageUrl)
            usernameLabel.text = matchUserProfile.name
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        let profileStackView = UIStackView(arrangedSubviews: [profileImageView, usernameLabel])
        profileStackView.axis = .vertical
        
        addSubview(profileStackView)
        profileStackView.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MatchMessagesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let customNavBar = MatchesTopNavigationBar()
    var users = [Match]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        fetchMatches()
    }
    
    fileprivate func fetchMatches() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUser).collection("matches").getDocuments { querySnapshot, error in
            if let err = error {
                print(err)
                return
            }
            querySnapshot?.documents.forEach({ documentSnapshot in
                print(documentSnapshot.data())
                let dictionary = documentSnapshot.data()
                self.users.append(Match(from: dictionary))
            })
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func setupLayout() {
        collectionView.backgroundColor = .white
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInset.top = 140
        view.addSubview(customNavBar)
        customNavBar.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .zero, size: .init(width: 0, height: 140))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    }
    
    //MARK: datasource/delegate functions
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MatchCell
        cell.matchUserProfile = users[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 80, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = users[indexPath.row]
        let chatLogControler = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogControler, animated: true)
    }

    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
}
