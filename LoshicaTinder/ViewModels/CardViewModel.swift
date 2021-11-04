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

class CardViewModel {
    // we'll define the properties that are view will display/ render out
    
    let imageNames: [String]
    let attibuterdText: NSAttributedString
    let textAligment: NSTextAlignment
    
    var imageIndexObserver: ((Int, UIImage) -> ())?
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageName = imageNames[imageIndex]
            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, image ?? UIImage())
        }
    }
    
    init(imageNames: [String], attibuterdText: NSAttributedString, textAligment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attibuterdText = attibuterdText
        self.textAligment = textAligment
    }
    
    func advanceNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(imageIndex - 1, 0)
    }
    
}
