//
//  RegistrationController.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 4.11.21.
//

import UIKit

class RegistrationController: UIViewController {

    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 15
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 44)
        tf.backgroundColor = .white
        tf.placeholder = "Enter full name"
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 44)
        tf.placeholder = "Enter email"
        tf.backgroundColor = .white
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 44)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.backgroundColor = UIColor(white: 1.1, alpha: 0.3)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        let height: CGFloat = 44
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.layer.cornerRadius = height / 2
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        
        setupLayout()
        
        setupNotificationObsrever()
        
        let dismissTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        self.view.addGestureRecognizer(dismissTapRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //setupFunctions
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    fileprivate func setupNotificationObsrever() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.transform = .identity
        }
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame.height)
        
        let bottomSpace = self.view.frame.height - self.stackView.frame.origin.y - self.stackView.frame.height
        print(bottomSpace)
        self.stackView.transform.translatedBy(x: 0, y: keyboardFrame.height - bottomSpace)
        let difference = keyboardFrame.height - bottomSpace
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -difference)
        }
    }
    
    fileprivate func setupLayout() {
        stackView = UIStackView(arrangedSubviews: [
            selectPhotoButton,
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupGradientLayer() {
        let layer = CAGradientLayer()
        layer.locations = [0, 1]
        let topColor = UIColor(red: 142/255, green: 45/255, blue: 226/255, alpha: 1)
        let bottomColor = UIColor(red: 74/255, green: 0, blue: 224/255, alpha: 1)
        layer.colors = [topColor.cgColor, bottomColor.cgColor ]
        view.layer.addSublayer(layer)
        layer.frame = view.bounds
    }
   
}
