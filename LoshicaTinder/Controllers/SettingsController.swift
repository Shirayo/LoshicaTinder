//
//  SettingsController.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 11.11.21.
//

import UIKit

class CustomImagePcikerController: UIImagePickerController {
    
    var imageButton: UIButton?
    
}

class SettingsController: UITableViewController {
   
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


    @objc fileprivate func handleSelectPhoto(button: UIButton) {
        let picker = CustomImagePcikerController()
        picker.delegate = self
        picker.imageButton = button
        present(picker, animated: true, completion: nil)
        print(button)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Settings"
      
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .done, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "logout", style: .done, target: self, action: #selector(handleCancel))
        ]
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    @objc fileprivate func handleCancel() {
        self.dismiss(animated: true)
    }
    
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePcikerController)?.imageButton
        imageButton?.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
    
        self.dismiss(animated: true, completion: nil)
    }
}
