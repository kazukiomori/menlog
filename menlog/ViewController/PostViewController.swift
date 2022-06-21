//
//  PostViewController.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/15.
//

import UIKit
import YPImagePicker
import Firebase

class PostViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shopnameTextField: UITextField!
    @IBOutlet weak var captionTextField: UITextField!
    
    var user:User?
    
    private let maxTextLength = 50
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageView.image == nil {
            let defaultImage = UIImage(named: "ラーメン")
            imageView.image = defaultImage
        }
        shopnameTextField.delegate = self
        captionTextField.delegate = self
        fetchUser()
    
    }
    // キャンセルボタンをタップしたら投稿画面を閉じる
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /// firestoreに投稿を保存する
    /// - Parameter sender: sender description
    @IBAction func tappedPostButton(_ sender: UIButton) {
        sender.isEnabled = false
        guard let shopname = shopnameTextField.text else {
            sender.isEnabled = true
            return
        }
        guard let caption = captionTextField.text else {
            sender.isEnabled = true
            return
        }
        guard let image = imageView.image else {
            sender.isEnabled = true
            return
        }
        guard let user = self.user else {
            sender.isEnabled = true
            return
        }
        
        PostService.uploadePost(shopname: shopname, caption: caption, image: image, user: user) { error in
            if let error = error {
                print("Faild to upload post\(error.localizedDescription)")
                sender.isEnabled = true
                return
            }
            sender.isEnabled = true
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func pickImage(_ sender: Any) {
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
            self.imageView.image = selectedImage
            
        }
    }
    
    // ユーザ情報を取得
    func fetchUser() {
        UserService.fetchUser() { user in
            self.user = user
        }
    }
    
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImageView else {return}
        self.imageView = selectedImage
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let shopname = shopnameTextField.text else { return }
        guard let caption = captionTextField.text else { return }
        
        if shopname.count > maxTextLength {
            shopnameTextField.text = String(shopname.prefix(maxTextLength))
        }
        
        if caption.count > maxTextLength {
            captionTextField.text = String(caption.prefix(maxTextLength))
        }
    }
}
