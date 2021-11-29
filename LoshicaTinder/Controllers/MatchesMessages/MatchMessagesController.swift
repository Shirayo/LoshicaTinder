//
//  MatchMessagesController.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 26.11.21.
//

import UIKit

class MatchCell: UICollectionViewCell {
    
    let profileImageView = UIImageView(image: UIImage(named: "nikita3"))
    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14), textColor: .black, textAlignment: .center, numberOfLines: 2)
    
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MatchCell
        print(indexPath.row)
        
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 80, height: 120)
    }
    
        
    var items = ["TEST1", "TEST2", "TEST3", "TEST4",]
    var colors: [UIColor] = [UIColor.red, .blue, .green, .orange]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInset.top = 150
        view.addSubview(customNavBar)
        customNavBar.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .zero, size: .init(width: 0, height: 140))
        customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)

    }

    @objc fileprivate func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
}
