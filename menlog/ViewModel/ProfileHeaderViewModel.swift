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
            return "設定"
        }
        return user.isFollowed ? "フォロー中" : "フォローする"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    var numberOfFollowers: NSAttributedString {
        return attributedStatText(value: user.stats.followers, label: "フォロワー")
    }
    
    var numberOfFollowing: NSAttributedString {
        return attributedStatText(value: user.stats.following, label: "フォロー")
    }
    
    var numberOfPosts: NSAttributedString {
        return attributedStatText(value: user.stats.posts, label: "投稿数")
    }
    
    init(user: User) {
        self.user = user
    }
    
    func attributedStatText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }
}
