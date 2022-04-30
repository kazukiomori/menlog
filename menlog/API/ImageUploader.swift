//
//  ImageUploader.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/13.
//

import FirebaseStorage

struct imageUploader {
    static func uploadImage (image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        let fileName = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(fileName)")
        
        ref.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print ("Error:\(error.localizedDescription)")
                return
            }
            ref.downloadURL{ (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}
