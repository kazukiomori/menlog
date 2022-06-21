//
//  SettitngViewController.swift
//  menlog
//
//  Created by Kazuki Omori on 2022/05/29.
//

import UIKit
import Firebase
import YPImagePicker

class SettitngViewController: UITableViewController {
    
    var user: User?
    
//    var settingTableView: UITableView  =   UITableView()
    
    var settingMenuArray: [String] = ["プロフイール画像の変更", "アカウントの削除"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
//        settingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        fetchUser()
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchUser() { user in
            self.user = user
        }
    }
    
    override func numberOfSections(in sampleTableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingMenuArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settingMenuArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if indexPath.row == 0 {
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
        } else if indexPath.row == 1 {
            let alert = UIAlertController(title: "タイトル", message: "本当にアカウントを削除しますか？", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.presentingViewController?.presentingViewController?.dismiss(animated: true)
                Auth.auth().currentUser?.delete() { [weak self] error in
                        guard let self = self else { return }
                        if error != nil {
                            let alert = UIAlertController(title: "タイトル", message: "アカウントを削除しました", preferredStyle: .alert)
                            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                                self.dismiss(animated: true, completion: nil)
                            }
                            alert.addAction(ok)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                self.dismiss(animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (acrion) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func didFinishPickingMedia (_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: true, completion: nil)
            
            guard let selectedImage = items.singlePhoto?.image else {return}
            imageUploader.uploadeProfileImage(image: selectedImage) {_ in
                
            }
        }
    }
}
