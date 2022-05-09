//
//  CommentService.swift
//  menlog
//
//  Created by Kazuki Omori on 2022/05/09.
//

import Firebase

struct CommentService {
    
    static func uploadComment(comment: String, postID: String, user: User,
                              completion: @escaping(FirestoreCompletion)) {
        let data: [String: Any] = ["uid": user.uid,
                                   "comment": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "username": user.name,
                                   "profileImageUrl": user.profileImageUrl]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data,
                                                                             completion: completion)
        
    }
    
    static func fetchComments() {
        
    }
}
