//
//  User.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 1.11.21.
//

import UIKit

struct User: ProdusesCardViewModel {
    
    //defining properties for our model layer
    
    var name: String?
    var age: Int?
    var profession: String?
//    let imageNames: [String]
    var imageUrl1: String?
    var uid: String?
    
    init(from dictionary: [String: Any]) {
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel{
        
        let information = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N/A"
        let professionString = profession != nil ? profession! : "job not selected"
        
        information.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)]))
        information.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)]))

        return CardViewModel(imageNames: [imageUrl1 ?? ""], attibuterdText: information, textAligment: .left)
    }
}
