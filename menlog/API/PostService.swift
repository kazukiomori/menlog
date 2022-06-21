//
//  PostService.swift
//  ramentabetai
//
//  Created by Kazuki Omori on 2022/04/19.
//

import UIKit
import Firebase

struct PostService {
    
    /// firestoreに投稿を保存する
    /// - Parameters:
    ///   - shopname: 投稿する店の名前
    ///   - caption: 感想など、短い説明
    ///   - image: お店や商品の画像
    ///   - user: 投稿するユーザ
    ///   - completion: completion description
    static func uploadePost(shopname: String, caption: String, image: UIImage, user:User, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        imageUploader.uploadImage(image: image) { imageUrl in
            var ref: DocumentReference? = nil
            let data = ["shopname": shopname,
                        "caption": caption,
                        "timeStamp": Timestamp(date: Date()),
                        "likes": 0,
                        "imageUrl": imageUrl,
                        "ownerUid": uid,
                        "ownerImageUrl": user.profileImageUrl,
                        "ownerUsername": user.name,
                        "postId": ""] as [String : Any]
            ref = COLLECTION_POSTS.addDocument(data: data, completion: completion)
            uploadPostId(postId: ref!.documentID)
        }
    }
    
    /// 投稿が完了した後に、postIdを投稿した内容に付け加える
    /// - Parameter postId: 投稿後に任意に割り振られるpostId
    static func uploadPostId(postId: String) {
        COLLECTION_POSTS.document(postId).setData(["postId": postId], merge: true)
    }
    
    /// 投稿された内容を全て取ってきて、投稿時間順に並べる
    /// - Parameter completion: completion description
    static func fetchPosts(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.order(by: "timeStamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {return}
            
            let posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            completion(posts)
        }
    }
    
    static func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        let query = COLLECTION_POSTS
            .whereField("ownerUid", isEqualTo: uid)
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {return}
            
            var posts = documents.map({ Post(postId: $0.documentID, dictionary: $0.data()) })
            
            posts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            completion(posts)
        }
    }
    
    static func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes" : post.likes + 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    static func unLlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard post.likes > 0 else { return }
        
        COLLECTION_POSTS.document(post.postId).updateData(["likes" : post.likes - 1])
        
        COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).delete { _ in
            COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
    }
    
    static func checkIfUserLikedPost(post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).getDocument { (snapshot, _) in
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
    
    static func deletePost() {
        
    }
}
