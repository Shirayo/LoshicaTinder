//
//  Match.swift
//  LoshicaTinder
//
//  Created by Vasily Mordus on 2.12.21.
//

import Foundation

struct Match {
    
    let name: String
    let profileImageUrl: String
    let uid: String
    
    init(from dict: [String: Any]) {
        self.name = dict["name"] as? String ?? ""
        self.profileImageUrl = dict["imageUrl"] as? String ?? ""
        self.uid = dict["uid"] as? String ?? ""
    }
    
    init(fromUser userDict: [String: Any]) {
        self.name = userDict["fullName"] as? String ?? ""
        self.profileImageUrl = userDict["imageUrl1"] as? String ?? ""
        self.uid = userDict["uid"] as? String ?? ""
    }
    
    init(from recentMessage: RecentMessage) {
        self.name = recentMessage.name
        self.profileImageUrl = recentMessage.profileImageUrl
        self.uid = recentMessage.uid
    }
}
