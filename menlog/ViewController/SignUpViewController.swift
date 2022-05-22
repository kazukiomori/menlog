//
//  ViewController.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/03/28.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import PKHUD

class SignUpViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = 10
        registerButton.isEnabled = false
        registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
        // NotificationCenterで通知を受け取る
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyBoard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func tappedRegisterButton(_ sender: Any) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        singUp(email: email, password: password)
    }
    
    func singUp(email:String, password:String) {
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
//                if let errCode = AuthErrorCode(err._code) {
//                    var errMessage:String
//                        switch errCode {
//                        case .emailAlreadyInUse:
//                            errMessage = "このメールアドレスは既に使われています。"
//                        case .invalidEmail:
//                            errMessage = "このメールアドレスは形式が違います。"
//                        case .weakPassword:
//                            errMessage = "パスワードが短いです。（6文字以上入力してください。）"
//                        default:
//                            errMessage = "エラーが起きました。\nしばらくしてから再度お試しください。"
//                        }
                    LoginViewController().showAlert(title: "アカウントの作成に失敗しました", message: "再度アカウントを作成してください")
                    return
//                    }
            }
            self.addUserInfoToDatabase(email: email)
        }
    }
    
    func addUserInfoToDatabase (email: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let name = self.usernameTextField.text else {return}
        
        let userRef = COLLECTION_USERS.document(uid)
        let docData = ["email": email, "name": name, "createdAt": Timestamp(),"uid": uid] as [String : Any]
        // Firestoreにユーザ情報を格納
        userRef.setData(docData) { (err) in
            if let err = err {
                print("Firestoreへの保存に失敗しました")
                return
            }
            // Firestoreからデータを取得
            userRef.getDocument{(docment, err) in
                if let err = err {
                    print("情報の取得に失敗しました")
                }
                let data = docment?.data()
            print("登録に成功しました")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func showKeyBoard (notification: Notification) {
        let keyboardFlame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFlame?.minY else {return}
        let registerButtonMaxY = registerButton.frame.maxY
        let distance = registerButtonMaxY - keyboardMinY
        // x,y方向に指定した分だけ動く
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.view.transform = transform
        })
    }
    
    @objc func hideKeyBoard () {
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.view.transform = .identity
        })
    }

    @IBAction func onTappedHaveAccountButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? true
        
        if (emailIsEmpty || passwordIsEmpty || usernameIsEmpty) {
            registerButton.isEnabled = false
            registerButton.backgroundColor = UIColor.rgb(red: 255, green: 221, blue: 187)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = UIColor.rgb(red: 255, green: 141, blue: 0)
        }
    }
}

