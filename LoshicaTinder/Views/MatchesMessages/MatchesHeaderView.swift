//
//  MatchHeaderView.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 2.12.21.
//

import Foundation
import UIKit
import LBTATools

class MatchesHeaderView: UICollectionReusableView {
    
    let newMatchesLabel = UILabel(text: "New Matches", font: UIFont.systemFont(ofSize: 16), textColor: .orange, textAlignment: .left, numberOfLines: 1)
    let messagesLabel = UILabel(text: "Messages", font: UIFont.systemFont(ofSize: 16), textColor: .orange, textAlignment: .left, numberOfLines: 1)

    let matchesHorizontalController = MatchesHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView(arrangedSubviews: [stack(newMatchesLabel).padLeft(16), matchesHorizontalController.view, stack(messagesLabel).padLeft(16)])
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.spacing = 20
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 16, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
