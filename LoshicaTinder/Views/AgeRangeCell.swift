//
//  AgeRangeCell.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 15.11.21.
//

import UIKit

class AgeRangeCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
