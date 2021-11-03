//
//  CardViewModel.swift
//  SwipeFoodFirestore
//
//  Created by Vasily Mordus on 2.11.21.
//

import Foundation
import UIKit

protocol ProdusesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
    // we'll define the properties that are view will display/ render out
    
    let imageNames: [String]
    let attibuterdText: NSAttributedString
    let textAligment: NSTextAlignment
    
}
