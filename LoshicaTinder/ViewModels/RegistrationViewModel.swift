//
//  RegistrationViewModel.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 5.11.21.
//

import UIKit
import Firebase
import FirebaseFirestore

class RegistrationViewModel {
    var fullname: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    var image = Observable<UIImage>()
    var isFormValid = Observable<Bool>()
    var isRegistering = Observable<Bool>()
    
    func checkFormValidity() {
        let isValid = fullname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && image.value != nil
        self.isFormValid.value = isValid
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        isRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            print("created")
            if let err = error {
                completion(err)
                return
            }
            //only upload images once you authorized
            
            self.saveImageToFirebase(completion: completion)
        }
            
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.image.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil) { (_, error) in
            if let err = error {
                completion(err)
                return
            }
            
            print("uploaded image")
            ref.downloadURL { url, error in
                if let err = error {
                    completion(err)
                    return
                }
                let imageUrl = url?.absoluteString ?? ""
                self.isRegistering.value = false
                self.saveInfoToFireStore(imageUrl: imageUrl, completion: completion)
                completion(nil)
            }
        }
    }
    
    fileprivate func saveInfoToFireStore(imageUrl: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData: [String: Any] = [
            "fullName": fullname ?? "",
            "uid": uid,
            "imageUrl1": imageUrl,
            "imageUrl2": "",
            "imageUrl3": "",
            "age": 18,
            "minSeekingAge": SettingsController.defaultMinSeekingAge,
            "maxSeekingAge": SettingsController.defaultMaxSeekingAge
        ]
        Firestore.firestore().collection("swipes").document(uid).setData([:])
        Firestore.firestore().collection("users").document(uid).setData(docData) { error in
            if let err = error {
                completion(err)
                return
            }
        }
    }
    
}
