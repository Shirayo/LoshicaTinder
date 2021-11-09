//
//  Bindable.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 8.11.21.
//

import Foundation

class Observable<T> {
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
//    init(_ value: T?) {
//        self.value = value
//    }
    
    private var listener: ((T?) -> Void)?
    
    func bind(_ listener: @escaping ((T?) -> Void)) {
        self.listener = listener
    }
    
}
