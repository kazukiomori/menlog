//
//  CommentViewModel.swift
//  menlog
//
//  Created by Kazuki Omori on 2022/05/13.
//

import UIKit

struct CommentViewModel {
    
    private let comment: Comment
    
    var commentText: String { return comment.commentText}
    
    init(comment: Comment) {
        self.comment = comment
    }
    
    func commentLabelText() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: comment.commentText, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        return attributedString
    }
    
    func size(forwidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.commentText
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
