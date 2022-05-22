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
import CoreLocation

protocol AuthenticationDelegate: class {
    func authenticationDidComplete()
}

var latitude: Double?
var longitude: Double?

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var locationManager : CLLocationManager?
    
    weak var delegate: AuthenticationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        requestLoacion()
        
        if CLLocationManager.locationServicesEnabled() {
            //位置情報の取得開始
            locationManager!.startUpdatingLocation()
        }
        
        view.backgroundColor = .white
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
//            if let err = err {
//                if let errCode = AuthErrorCode(rawValue: err._code) {
//                    var errMessage:String
//                    switch errCode {
//                    case .invalidEmail:
//                        errMessage = "メールアドレスが違います。"
//                    case .wrongPassword:
//                        errMessage = "パスワードが違います。"
//                    case .userNotFound:
//                        errMessage = "ユーザがいません。"
//                    default:
//                        errMessage = "エラーが起きました。\nしばらくしてから再度お試しください。"
//                    }
                    self.showAlert(title: "ログインできませんでした", message: "再度ログインしてください")
                    return
//                }
            }
            self.delegate?.authenticationDidComplete()
        }
    
    func showAlert(title: String, message: String?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default,handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func tappedNotHaveAccountButton(_ sender: Any) {
    }
    
    private func requestLoacion() {
        // ユーザにアプリ使用中のみ位置情報取得の許可を求めるダイアログを表示
        locationManager?.requestWhenInUseAuthorization()
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
extension LoginViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         guard let newLocation = locations.last else { return }
         let location:CLLocationCoordinate2D
                = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
         let formatter: DateFormatter = DateFormatter()
         formatter.timeZone   = TimeZone(identifier: "Asia/Tokyo")
         formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
         let date = formatter.string(from: newLocation.timestamp)
        latitude = location.latitude
        longitude = location.longitude
        print("緯度：", location.latitude, "経度：", location.longitude, "時間：", date)

    }
}
