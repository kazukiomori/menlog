//
//  ImageUploader.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/13.
//

import FirebaseStorage
import Firebase

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
    
    static func uploadeProfileImage(image: UIImage, completion: @escaping(FirestoreCompletion)) {
        imageUploader.uploadImage(image: image) { imageUrl in
            uploadUserProfileImage(imageUrl: imageUrl)
        }
    }
    
    static func uploadUserProfileImage(imageUrl: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).setData(["profileImageUrl": imageUrl], merge: true)
    }
}
