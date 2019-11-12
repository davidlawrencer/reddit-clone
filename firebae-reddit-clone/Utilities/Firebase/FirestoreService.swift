//
//  FirestoreService.swift
//  firebae-reddit-clone
//
//  Created by David Rifkin on 11/12/19.
//  Copyright © 2019 David Rifkin. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirestoreService {    
    static let manager = FirestoreService()
    
    private let db = Firestore.firestore()
    
    //MARK: AppUsers
    func createAppUser(user: AppUser, completion: @escaping (Result<(), Error>) -> ()) {
        db.collection("users").document(user.uid).setData(user.fieldsDict) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
    
    func getAllUsers(completion: @escaping (Result<[AppUser], Error>) -> ()) {
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let users = snapshot?.documents.compactMap({ (snapshot) -> AppUser? in
                    let userID = snapshot.documentID
                    let user = AppUser(from: snapshot.data(), id: userID)
                    return user
                })
                completion(.success(users ?? []))
            }
        }
    }
    
    //MARK: Posts
    func createPost(post: Post, completion: @escaping (Result<(), Error>) -> ()) {
        db.collection("posts").addDocument(data: post.fieldsDict) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getAllPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
        db.collection("posts").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let posts = snapshot?.documents.compactMap({ (snapshot) -> Post? in
                    let postID = snapshot.documentID
                    let post = Post(from: snapshot.data(), id: postID)
                    return post
                })
                completion(.success(posts ?? []))
            }
        }
    }
    
    func getPosts(forUserID: String, completion: @escaping (Result<[Post], Error>) -> ()) {
        
    }
    
    //MARK: Comments
    func createComment(comment: Comment, completion: @escaping (Result<(), Error>) -> ()) {
        
    }
    
    func getComments(forPostID: String, completion: @escaping (Result<[Comment], Error>) -> ()) {
        
    }
    
    func getComments(forUserID: String, completion: @escaping (Result<[Comment], Error>) -> ()) {
        
    }
    
    private init () {}
}
