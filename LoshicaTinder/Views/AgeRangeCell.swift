//
//  AgeRangeCell.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 15.11.21.
//

import UIKit

class AgeRangeCell: UITableViewCell {

    let minAgeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        slider.setValue(18, animated: true)
        return slider
    }()
    
    let maxAgeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        slider.setValue(35, animated: true)
        return slider
    }()
    
    class CustomLabel: UILabel {
        
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
        
    }
        
    let minLabel: UILabel = {
        let label = CustomLabel()
        label.text = "Min 18"
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = CustomLabel()
        label.text = "Max 35"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let cellStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minAgeSlider]),
            UIStackView(arrangedSubviews: [maxLabel, maxAgeSlider])
        ])
        cellStackView.distribution = .fillEqually
        cellStackView.axis = .vertical
        contentView.addSubview(cellStackView)
        cellStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        cellStackView.spacing = 16
    }
    
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
