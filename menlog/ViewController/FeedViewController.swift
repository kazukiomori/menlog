//
//  FeedViewController.swift
//  menlog
//
//  Created by Kazuki Omori on 2022/04/30.
//

import UIKit

let screenSize: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)

class FeedViewController: UIViewController {
    
    
//    @IBOutlet weak var collectionView: UICollectionView!
    
    private var posts = [Post]()
    
    var post: Post?
    var user: User?
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), collectionViewLayout: flowLayout)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "FeedCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        flowLayout.itemSize = CGSize(width: 100, height: 100)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        fetchPost()
        fetchUser()
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        view.addSubview(collectionView)
    }
    
    func fetchPost() {
        guard post == nil else { return }
        PostService.fetchPosts { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPost()
    }
}

extension FeedViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCell
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            if indexPath.row <= posts.count {
                cell.viewModel = PostViewModel(post: posts[indexPath.row])
            }
        }
        return cell
    }
    
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: 300, height: width)
    }
}

extension FeedViewController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentViewController(post: post, user: user!)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
