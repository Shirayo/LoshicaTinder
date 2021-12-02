//
//  MatchesHorizontalController.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 2.12.21.
//

import UIKit
import LBTATools
import Firebase
import FirebaseFirestore

protocol MatchesHorizontalControllerDelegate {
    func didSelectItem(match: Match)
}

class MatchesHorizontalController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {
    
    var delegate: MatchesHorizontalControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        fetchMatches()
    }
    
    fileprivate func fetchMatches() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("matches_messages").document(currentUser).collection("matches").getDocuments { querySnapshot, error in
            if let err = error {
                print(err)
                return
            }
            
            var matches = [Match]()
            
            querySnapshot?.documents.forEach({ documentSnapshot in
                print(documentSnapshot.data())
                let dictionary = documentSnapshot.data()
                matches.append(Match(from: dictionary))
            })
            self.items = matches
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(match: items[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: view.frame.height)
    }
    
}
