//
//  CustomInputAccessoryView.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 1.12.21.
//

import UIKit

class CustomInputAccessView: UIView {
    
    let placeHolderLabel: UILabel = {
       let ph = UILabel()
        ph.text = "Enter Message"
        ph.font = UIFont.systemFont(ofSize: 16)
        ph.textColor = .lightGray
        return ph
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()

    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
        translatesAutoresizingMaskIntoConstraints = false
        autoresizingMask = .flexibleHeight
        
        sendButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [textView, sendButton])
        addSubview(stackView)
        stackView.alignment = .center
        stackView.fillSuperView()
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 16))
        placeHolderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc fileprivate func handleTextChange() {
        placeHolderLabel.isHidden = textView.text.count != 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
