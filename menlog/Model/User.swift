//
//  User.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/21.
//

import Foundation
import Firebase

struct User {
    let email: String
    let name: String
    let profileImageUrl: String
    let uid: String
    
    var isFollowed = false
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
