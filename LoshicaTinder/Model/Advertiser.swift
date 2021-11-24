//
//  Advetiser.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 2.11.21.
//

import Foundation
import UIKit

struct Advertiser: ProdusesCardViewModel {
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    
    func toCardViewModel() -> CardViewModel{
        let advertiserText = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
        advertiserText.append(NSAttributedString(string: "\n \(brandName)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
        
        return CardViewModel(imageNames: [posterPhotoName], attibuterdText: advertiserText, textAligment: .center, uid: "")
    }
}
