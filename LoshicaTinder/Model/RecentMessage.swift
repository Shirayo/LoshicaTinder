//
//  RecentMessage.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 2.12.21.
//

import Foundation
import Firebase

struct RecentMessage {
    let text, uid, name, profileImageUrl: String
    let timestamp: Timestamp
    
    init(from dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.text = dict["text"] as? String ?? ""
        self.profileImageUrl = dict["imageUrl"] as? String ?? ""
        self.timestamp = dict["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.uid = dict["uid"] as? String ?? ""
    }
}
