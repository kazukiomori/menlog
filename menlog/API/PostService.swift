//
//  PostService.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/19.
//

import UIKit
import Firebase

struct PostService {
    
    static func uploadePost(shopname: String, caption: String, image: UIImage, profileImageUrl: URL, name: String, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        imageUploader.uploadImage(image: image) { imageUrl in
            let data = ["shopname": shopname,
                        "caption": caption,
                        "timeStamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageUrl,
                        "ownerUid": uid,
                        "ownerImageUrl": profileImageUrl,
                        "ownerUsername": name] as [String : Any]
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timeStamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {return}
            
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            completion(posts)
        }
    }
}
