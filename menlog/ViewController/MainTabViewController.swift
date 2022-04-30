//
//  MainTabViewController.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/14.
//

import UIKit
import FirebaseAuth

class MainTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfUserIsLogin()
    }
    
    func checkIfUserIsLogin() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginViewController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
}
