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
    
    var imageIndexObserver: (() -> ())?
    
    fileprivate var imageIndex = 0 {
        didSet {
            imageIndexObserver?()
        }
    }
    
    init(imageNames: [String], attibuterdText: NSAttributedString, textAligment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attibuterdText = attibuterdText
        self.textAligment = textAligment
    }
    
    func advanceNextPhoto() {
        imageIndex += 1
    }
    
    func goToPreviousPhoto() {
        imageIndex -= 1
    }
    
}
