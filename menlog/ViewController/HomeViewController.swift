//
//  HomeViewController.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/12.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var HomeViewTableView: UITableView!
    
    private var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.HomeViewTableView.dataSource = self
        self.checkIfUserIsLogin()
        fetchPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserIsLogin()
    }
    
    func fetchPosts() {
        PostService.fetchPosts { posts in
            self.posts = posts
            
        }
    }
    func checkIfUserIsLogin() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginViewController()
                loginVC.delegate = self
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: false, completion: nil)
            }
        }
    }
    // テーブルビューのセクション数を返す
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // TableViewに表示するセルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    // 各セルを生成して返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell", for: indexPath) as! HomeViewTableViewCell
        return cell
    }
}

extension HomeViewController: AuthenticationDelegate {
    func  authenticationDidComplete() {
        print("ログインに成功しました")
        
    }
}
