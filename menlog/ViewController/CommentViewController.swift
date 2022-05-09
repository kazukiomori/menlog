//
//  CommentViewController.swift
//  menlog
//
//  Created by Kazuki Omori on 2022/05/07.
//

import UIKit

class CommentViewController: UIViewController {
    
    private let post: Post
    var user: User?
    
    private lazy var commentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    init(post: Post, user: User) {
        self.post = post
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    @IBOutlet weak var collectionView: UICollectionView!
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), collectionViewLayout: flowLayout)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: "CommentCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        navigationItem.title = "コメント"
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func fetchUser() {
        UserService.fetchUser { fetchuser in
            self.user = fetchuser
        }
    }
    
}

extension CommentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentCell", for: indexPath)
        return cell
    }
}

extension CommentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}

extension CommentViewController: CommentInputAccesoryViewDelegate {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
        UserService.fetchUser { fetchuser in
            self.user = fetchuser
        }
        guard  let user = user else { return }
            CommentService.uploadComment(comment: comment, postID: post.postId, user: user) { error in
                    inputView.clearCommentTextView()
        }
    }
}
