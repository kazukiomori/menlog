//
//  Comment.swift
//  menlog
//
//  Created by Kazuki Omori on 2022/05/12.
//

import Firebase

struct Comment {
    let uid: String
    let timestamp: Timestamp
    let commentText: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.commentText = dictionary["comment"] as? String ?? ""
    }
}
