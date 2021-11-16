//
//  LoginViewModel.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 16.11.21.
//

import Foundation
import Firebase

class LoginViewModel {
    
    var isLoggingIn = Observable<Bool>()
    var isFormValid = Observable<Bool>()
    
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    fileprivate func checkFormValidity() {
        let isValid = email?.isEmpty == false && password?.isEmpty == false
        isFormValid.value = isValid
    }
    
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        isLoggingIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            completion(err)
        }
    }
}
