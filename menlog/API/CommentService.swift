//
//  CommentService.swift
//  menlog
//
//  Created by Kazuki Omori on 2022/05/09.
//

import Firebase

struct CommentService {
    
    static func uploadComment(comment: String, postID: String,
                              completion: @escaping(FirestoreCompletion)) {
        guard  let uid = Auth.auth().currentUser?.uid else { return }
        let data: [String: Any] = ["uid": uid,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date())]
//                                   "username": user.name,
//                                   "profileImageUrl": user.profileImageUrl]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data,
                                                                             completion: completion)
        
    }
    
    static func fetchComments(forPost postId: String, completion: @escaping([Comment]) -> Void) {
        var commnets = [Comment]()
        let query = COLLECTION_POSTS.document(postId).collection("comments").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let comment = Comment(dictionary: data)
                    commnets.append(comment)
                }
            })
            completion(commnets)
        }
    }
}
