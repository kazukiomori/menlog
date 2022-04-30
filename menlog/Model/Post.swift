//
//  Post.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/28.
//

import Foundation
import Firebase

struct Post {
    var shopName: String
    var caption: String
    var likes: Int
    let imageUrl: String
    let owenerUid: String
    let timestamp: Timestamp
    let postId: String
    
    init(postId: String, dictionary: [String: Any]) {
        self.shopName = dictionary["shopName"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.owenerUid = dictionary["owenerUid"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.postId = dictionary["postId"] as? String ?? ""
    }
}
