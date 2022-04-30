//
//  LoginViewController.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/01.
//

import UIKit
import Firebase
import FirebaseAuth
import PKHUD

protocol AuthenticationDelegate: class {
    func authenticationDidComplete()
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    weak var delegate: AuthenticationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton?.layer.cornerRadius = 10
        loginButton?.isEnabled = false
        loginButton?.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        
        emailTextField?.delegate = self
        passwordTextField?.delegate = self
    }
    
    @IBAction func tappedLoginButton(_ sender: Any) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        login(email: email, password: password)
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                if let errCode = AuthErrorCode(rawValue: err._code) {
                    var errMessage:String
                    switch errCode {
                    case .invalidEmail:
                        errMessage = "メールアドレスが違います。"
                    case .wrongPassword:
                        errMessage = "パスワードが違います。"
                    case .userNotFound:
                        errMessage = "ユーザがいません。"
                    default:
                        errMessage = "エラーが起きました。\nしばらくしてから再度お試しください。"
                    }
                    self.showAlert(title: "ログインできませんでした", message: errMessage)
                    return
                }
            }
            self.delegate?.authenticationDidComplete()
        }
    }
    
    func showAlert(title: String, message: String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func tappedNotHaveAccountButton(_ sender: Any) {
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if (emailIsEmpty || passwordIsEmpty) {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
        }
    }
}
