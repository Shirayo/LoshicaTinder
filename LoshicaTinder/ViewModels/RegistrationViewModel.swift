//
//  RegistrationViewModel.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 5.11.21.
//

import UIKit

class RegistrationViewModel {
    var fullname: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    var image = Observable<UIImage>()
    var isFormValid = Observable<Bool>()
    
    func checkFormValidity() {
        let isValid = fullname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        self.isFormValid.value = isValid
    }
    
}
