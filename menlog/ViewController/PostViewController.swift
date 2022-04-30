//
//  PostViewController.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/15.
//

import UIKit
import YPImagePicker

class PostViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var captionTextField: UITextField!
    
    private let maxTextLength = 50
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageView.image == nil {
            let defaultImage = UIImage(named: "ラーメン")
            imageView.image = defaultImage
        }
        shopNameTextField.delegate = self
        captionTextField.delegate = self
    }
    
    func didFinishPickingMedia (_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: true, completion: nil)
            
            guard let selectedImage = items.singlePhoto?.image else {return}
            self.imageView.image = selectedImage
        }
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tappedPostButton(_ sender: Any) {
        guard let shopName = shopNameTextField.text else {return}
        guard let caption = captionTextField.text else {return}
        guard let image = imageView.image else {return}
        PostService.uploadePost(shopName: shopName, caption: caption, image: image) { error in
            if let error = error {
                print("Faild to upload post\(error.localizedDescription)")
                return
            }
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
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImageView else {return}
        self.imageView = selectedImage
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let shopName = shopNameTextField.text else { return }
        guard let caption = captionTextField.text else { return }
        
        if shopName.count > maxTextLength {
            shopNameTextField.text = String(shopName.prefix(maxTextLength))
        }
        
        if caption.count > maxTextLength {
            captionTextField.text = String(caption.prefix(maxTextLength))
        }
    }
}
