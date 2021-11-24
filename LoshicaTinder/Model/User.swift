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
    var imageUrl1: String
    var imageUrl2: String
    var imageUrl3: String


    var uid: String?
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(from dictionary: [String: Any]) {
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String ?? ""
        self.name = dictionary["fullName"] as? String ?? ""
//        self.images = dictionary["images"] as? [String] ?? [""]
        
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        self.imageUrl2 = dictionary["imageUrl2"] as? String ?? ""
        self.imageUrl3 = dictionary["imageUrl3"] as? String ?? ""

        self.uid = dictionary["uid"] as? String ?? ""
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int

    }
    
    func toCardViewModel() -> CardViewModel {
        
        let information = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N/A"
        let professionString = profession != nil ? profession! : "job not selected"
        
        information.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)]))
        information.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)]))
        
        var images = [String]()
        [imageUrl1, imageUrl2, imageUrl3].forEach { imageUrl in
            if imageUrl != "" {
                images.append(imageUrl)
            }
        }
        
        return CardViewModel(imageNames: images, attibuterdText: information, textAligment: .left, uid: self.uid ?? "")
    }
}
