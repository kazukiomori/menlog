//
//  CommentInputAccesoryView.swift
//  menlog
//
//  Created by Kazuki Omori on 2022/05/08.
//

import UIKit

protocol CommentInputAccesoryViewDelegate: class {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String)
}

class CommentInputAccesoryView: UIView {
    
    weak var delegate: CommentInputAccesoryViewDelegate?
    
    private let commentTextView: UITextField = {
        let tf = UITextField()
        tf.placeholder = "コメントを入力してください"
        tf.font = UIFont.systemFont(ofSize: 15)
        return tf
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("投稿", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor, paddingRight: 8)
        postButton.setDimensions(height: 50, width: 50)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor,
                               bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor,
                               paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        commentTextView.centerY(inView: self)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    @objc func handlePostTapped(){
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text!)
    }
    
    func clearCommentTextView() {
        commentTextView.text = nil
    }
}
