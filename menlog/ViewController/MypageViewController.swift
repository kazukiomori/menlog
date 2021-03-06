//
//  MypageViewController.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/13.
//

import UIKit
import Firebase
import YPImagePicker

private let headerIdentifer = "ProfileHeader"

class MypageViewController: UIViewController {
    
    // userの値が更新されたタイミングでcollectionViewも更新する
    var user:User? {
        didSet { collectionView.reloadData() }
    }
    
    private var posts = [Post]()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), collectionViewLayout: flowLayout)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: "ProfileCell")
        return collectionView
    }()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
//
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        if fromFeedViewController {
            fetchOtherUser()
        } else {
            fetchUser()
        }
        
        fetchPost()
        fetchUserStats()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureCollectionView()
        if fromFeedViewController {
            fetchOtherUser()
        } else {
            fetchUser()
        }
    }
    
    @objc func changeProfileImageButton(_ sender: Any) {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library]
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        picker.modalPresentationStyle = .fullScreen
        
        self.present(picker, animated: true, completion: nil)
        
        didFinishPickingMedia(picker)
    }
    
    func didFinishPickingMedia (_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: true, completion: nil)
            
            guard let selectedImage = items.singlePhoto?.image else {return}
            imageUploader.uploadeProfileImage(image: selectedImage) {_ in
                
            }
        }
    }
    
    func fetchUser() {
        UserService.fetchUser() { user in
            self.user = user
            self.navigationItem.title = user.name
            self.checkIfUserIsFollowed()
        }
    }
    func fetchOtherUser() {
        UserService.fetchUser(withUid: user?.uid) { user in
            fromFeedViewController = false
            self.user = user
            self.navigationItem.title = user.name
            self.checkIfUserIsFollowed()
        }
    }
    
    func fetchUserStats() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUserStats(uid: uid) { stats in
            self.user?.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Error Signout!")
        }
    }
    
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user!.uid) { isFolliwd in
            self.user?.isFollowed = isFolliwd
            self.collectionView.reloadData()
        }
    }
    
//    TODO Feed画面から来たか判別するフラグを用意する
//    フラグが立っているときはuser.uid フラグなしの場合はAuth.auth().currentUser?.uid
    func fetchPost() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        PostService.fetchPosts(forUser: uid) { posts in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    func configureCollectionView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "＋",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(changeProfileImageButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ログアウト",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleLogout))
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: "ProfileCell")
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ProfileHeader")
    }
}

extension MypageViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeader", for: indexPath) as! ProfileHeader

        header.delegate = self
        if let user = user {
            header.viewModel = ProfileHeaderViewModel(user: user)
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedViewController()
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MypageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.1
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = view.frame.width
        return CGSize(width: 300, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

extension MypageViewController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        if user.isCurrentUser {
            let controller = SettitngViewController()
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        } else if user.isFollowed {
            UserService.unfollow(uid: user.uid) { error in
                self.user?.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                self.user?.isFollowed = true
                self.collectionView.reloadData()
            }
        }
    }
}
