//
//  ProfileHeaderViewModel.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/24.
//

import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var name: String {
        return user.name
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl) 
    }
    
    var followButtonText: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    init(user: User) {
        self.user = user
    }
}
