//
//  RegistrationController.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 4.11.21.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationController: UIViewController {

    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 275).isActive = true
        button.widthAnchor.constraint(equalToConstant: 275).isActive = true
        button.layer.cornerRadius = 15
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 44)
        tf.backgroundColor = .white
        tf.placeholder = "Enter full name"
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 44)
        tf.placeholder = "Enter email"
        tf.backgroundColor = .white
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: CustomTextField = {
        let tf = CustomTextField(padding: 16, height: 44)
        tf.placeholder = "Enter password"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
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
        button.setTitleColor(.red, for: .disabled)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
            
    let gradientLayer = CAGradientLayer()

    lazy var verticalStackView: UIStackView = {
        let verticalStack = UIStackView(arrangedSubviews: [
            fullNameTextField,
            emailTextField,
            passwordTextField,
            registerButton
        ])
        verticalStack.spacing = 8
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillEqually
        return verticalStack
    }()
    
    lazy var overallStackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        verticalStackView
    ])
    
    let registrationViewModel = RegistrationViewModel()
    
    
    //MARK: override functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setOverallStackViewOrientation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupGradientLayer()
        
        setupLayout()
        
        setupNotificationObsrever()
        
        setupRegistrationViewModeControler()
        
        let dismissTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        self.view.addGestureRecognizer(dismissTapRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       setOverallStackViewOrientation()
    }
    
    fileprivate func setOverallStackViewOrientation() {
        if self.traitCollection.verticalSizeClass == .compact {
            overallStackView.axis = .horizontal
        } else {
            overallStackView.axis = .vertical
        }
    }
    
    //MARK: setup functions
    
    fileprivate func setupLayout() {
        view.addSubview(overallStackView)
        overallStackView.axis = .vertical
        overallStackView.spacing = 8
        overallStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupNotificationObsrever() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.locations = [0, 1]
        let topColor = UIColor(red: 142/255, green: 45/255, blue: 226/255, alpha: 1)
        let bottomColor = UIColor(red: 74/255, green: 0, blue: 224/255, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor ]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    
    fileprivate func setupRegistrationViewModeControler() {
    
        registrationViewModel.isFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
            self.registerButton.isEnabled = isFormValid ?  true : false
            print("form is changind, is it valid? ", isFormValid)
        }
        
        registrationViewModel.image.bind { [unowned self] img in
            selectPhotoButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            selectPhotoButton.clipsToBounds = true
        }
        
        registrationViewModel.isRegistering.bind { [unowned self] isRegistering in
            if isRegistering == true {
                self.registerHUD.textLabel.text = "Register"
                self.registerHUD.show(in: self.view)
            } else {
                self.registerHUD.dismiss(animated: true)
            }
        }
        
    }
    
    //MARK: handling functions
    
    @objc fileprivate func handleTapDismiss() {
        self.view.endEditing(true)
    }
    
    @objc fileprivate func handleKeyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.transform = .identity
        }
    }
    
    @objc fileprivate func handleSelectPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame.height)
        
        let bottomSpace = self.view.frame.height - self.overallStackView.frame.origin.y - self.overallStackView.frame.height
        print(bottomSpace)
        self.overallStackView.transform.translatedBy(x: 0, y: keyboardFrame.height - bottomSpace)
        let difference = keyboardFrame.height - bottomSpace
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 16)
        }
    }
    
    @objc fileprivate func handleTextChange(textField: UITextField) {
        if textField == fullNameTextField {
            registrationViewModel.fullname = textField.text
        } else if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else {
            registrationViewModel.password = textField.text
        }
    }
    
    @objc fileprivate func handleRegister() {
        self.handleTapDismiss()
            registrationViewModel.performRegistration { error in
            if let err = error {
                print(err)
                self.showHUDWithError(error: err)
                return
            }
        }
    }
    
    let registerHUD = JGProgressHUD(style: .dark)
    
    fileprivate func showHUDWithError(error: Error) {
        self.registerHUD.dismiss(animated: true)
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1.5)
    }
    
}

//MARK: extensions

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        self.registrationViewModel.image.value = image
        self.dismiss(animated: true, completion: nil)
    }
}
