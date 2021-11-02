//
//  User.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 1.11.21.
//

import UIKit

struct User {
    
    //defining properties for our model layer
    
    let name: String
    let age: Int
    let profession: String
    let imageName: String
    
    
    func toCardView() -> CardViewModel{
        
        let information = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        information.append(NSAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)]))
        information.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .medium)]))

        return CardViewModel(imageName: imageName, attibuterdText: information, textAligment: .left)
    }
}
