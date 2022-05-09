//
//  CommentCell.swift
//  menlog
//
//  Created by Kazuki Omori on 2022/05/07.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        
        let attributedString = NSMutableAttributedString(string: "かずき ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedString.append(NSAttributedString(string: "テストコメント", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attributedString
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(commentLabel)
        commentLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
