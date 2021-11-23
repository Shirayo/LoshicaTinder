//
//  SettingsController.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 11.11.21.
//

import UIKit
import FirebaseFirestore
import Firebase
import SDWebImage
import JGProgressHUD

class CustomImagePickerController: UIImagePickerController {
    
    var imageButton: UIButton?
    
}

protocol SettingsControllerDelegate {
    func didSavedSettings()
}

class SettingsController: UITableViewController {
   
    static let defaultMinSeekingAge = 18
    static let defaultMaxSeekingAge = 35
    
    var delegate: SettingsControllerDelegate?
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("selectPhoto", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 16
        return button
    }
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var imageButtons = [image1Button, image2Button, image3Button]
    
    var isImageChanged = [false, false, false]
    var user: User?
    lazy var header: UIView = {
        let header = UIView()
        let padding: CGFloat = 16
        header.addSubview(image1Button)
        image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        header.addSubview(stackView)
        stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor, bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return header
    }()
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .grouped) //fixes header bug
        setupNavBar()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        fetchCurrentUser()
        
    }
    
    fileprivate func fetchCurrentUser() {
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(userUid).getDocument { docSnapshot, error in
            if let err = error {
                print(err)
                return
            }
            guard let dictionary = docSnapshot?.data() else { return }
            self.user = User(from: dictionary)
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        
        if let imageString = user?.imageUrl1, let imageUrl1 = URL(string: imageString) {
            print("found image1")
            SDWebImageManager.shared.loadImage(with: imageUrl1, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageString = user?.imageUrl2, let imageUrl2 = URL(string: imageString) {
            print("found image2")
            SDWebImageManager.shared.loadImage(with: imageUrl2, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageString = user?.imageUrl3, let imageUrl3 = URL(string: imageString) {
            print("found image3")
            SDWebImageManager.shared.loadImage(with: imageUrl3, options: .continueInBackground, progress: nil) { image, _, _, _, _, _ in
                self.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    fileprivate func setupNavBar() {
        self.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .done, target: self, action: #selector(handleBack))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "logout", style: .done, target: self, action: #selector(handleLogout))
        ]
    }
    
//    fileprivate func saveToStorage() {
//        let filename = UUID().uuidString
//        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
//        imageButtons.forEach { button in
//            if let image = button.imageView?.image, let imageData = image.jpegData(compressionQuality: 0.75) {
//                self.dispatchGroup.enter()
//                ref.putData(imageData, metadata: nil) { (_, error) in
//                    if let err = error {
//                        print("error: \(err)")
//                        return
//                    }
//                    self.dispatchGroup.enter()
//                    ref.downloadURL { url, error in
//                        if let err = error {
//                            print("error: \(err)")
//                            return
//                        }
//                        let imageUrl = url?.absoluteString ?? ""
//                        if button == self.image1Button {
//                            print("heh1")
//                            self.user?.imageUrl1 = imageUrl
//                        } else if button == self.image2Button {
//                            print("heh2")
//                            self.user?.imageUrl2 = imageUrl
//                        } else {
//                            print("heh3")
//                            self.user?.imageUrl3 = imageUrl
//                        }
//                        self.dispatchGroup.leave()
//                    }
//                    self.dispatchGroup.leave()
//
//                }
//            }
//        }
//
//    }
    
    //MARK: tableView datasource/delegate functions
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        case 5:
            headerLabel.text = "Seeking Age Range"
        default:
            headerLabel.text = "default"
        }
        return headerLabel
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 300 : 40
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minAgeSlider.addTarget(self, action: #selector(HandleMinAgeSliderValueChanged), for: .valueChanged)
            ageRangeCell.maxAgeSlider.addTarget(self, action: #selector(HandleMaxAgeSliderValueChanged), for: .valueChanged)
            if let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge {
                ageRangeCell.minLabel.text = "Min \(minAge)"
                ageRangeCell.minAgeSlider.setValue(Float(minAge), animated: false)
                ageRangeCell.maxLabel.text = "Max \(maxAge)"
                ageRangeCell.maxAgeSlider.setValue(Float(maxAge), animated: false)
            }
            
            return ageRangeCell
        }
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter age"
            if let age = user?.age {
                cell.textField.text = String(age)
                cell.textField.keyboardType = .numberPad
                cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            }
        case 4 :
            cell.textField.placeholder = "Enter bio"
        default:
            cell.textField.placeholder = "default placeholder"
        }
        return cell
    }
    
    //MARK: handle functions
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    @objc fileprivate func handleBack() {
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let hud = JGProgressHUD.init(style: .dark)
        hud.textLabel.text = "saving"
        hud.show(in: self.view)
//        self.saveToStorage()
        dispatchGroup.notify(queue: DispatchQueue.main) { [unowned self] in
            let savedData: [String: Any] = [
                "uid": uid,
                "fullName": user?.name ?? "",
                "profession": user?.profession ?? "",
                "imageUrl1": user?.imageUrl1 ?? "",
                "imageUrl2": user?.imageUrl2 ?? "",
                "imageUrl3": user?.imageUrl3 ?? "",
                "age": user?.age ?? -1,
                "minSeekingAge": user?.minSeekingAge ?? SettingsController.defaultMinSeekingAge,
                "maxSeekingAge": user?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
            ]
            Firestore.firestore().collection("users").document(uid).setData(savedData) { error in
                if let _ = error {
                    hud.textLabel.text = "error in saving data"
                    hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    hud.dismiss(afterDelay: 1.5)
                } else {
                    hud.textLabel.text = "data saved successfully"
                    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    hud.dismiss(afterDelay: 1)
                }
            }
            self.dismiss(animated: true) {
                self.delegate?.didSavedSettings()
            }
        }
    }
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        self.dismiss(animated: true)
    }
    
    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        let picker = CustomImagePickerController()
        picker.delegate = self
        picker.imageButton = button
        present(picker, animated: true, completion: nil)
    }
    
    @objc fileprivate func HandleMinAgeSliderValueChanged(slider: UISlider) {
        let ageValue = slider.value.rounded()
        user?.minSeekingAge = Int(ageValue)
        let indexPath = IndexPath(row: 0, section: 5)
        let cell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        if ageValue > cell.maxAgeSlider.value {
            cell.maxAgeSlider.setValue(ageValue, animated: true)
            cell.maxLabel.text = "Max \(Int(ageValue))"
        }
        cell.minLabel.text = "Min \(Int(ageValue))"
    }
    
    @objc fileprivate func HandleMaxAgeSliderValueChanged(slider: UISlider) {
        let ageValue = slider.value.rounded()
        user?.maxSeekingAge = Int(ageValue)
        let indexPath = IndexPath(row: 0, section: 5)
        let cell = tableView.cellForRow(at: indexPath) as! AgeRangeCell
        if ageValue < cell.minAgeSlider.value {
            cell.minAgeSlider.setValue(ageValue, animated: true)
            cell.minLabel.text = "Min \(Int(ageValue))"
        }
        cell.maxLabel.text = "Max \(Int(ageValue))"
    }
    
}

//MARK: extensions

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading image..."
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil) { (nil, err) in
            if let err = err {
                hud.dismiss()
                print("Failed to upload image to storage:", err)
                return
            }
            
            print("Finished uploading image")
            ref.downloadURL(completion: { (url, err) in
                
                hud.dismiss()
                
                if let err = err {
                    print("Failed to retrieve download URL:", err)
                    return
                }
                
                print("Finished getting download url:", url?.absoluteString ?? "")
                
                if imageButton == self.image1Button {
                    self.user?.imageUrl1 = url?.absoluteString ?? ""
                } else if imageButton == self.image2Button {
                    self.user?.imageUrl2 = url?.absoluteString ?? ""
                } else {
                    self.user?.imageUrl3 = url?.absoluteString ?? ""
                }
            })
        }
    }
}
