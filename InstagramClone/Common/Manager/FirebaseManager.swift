//
//  FirebaseManager.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 29/09/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import FirebaseStorage

class FirebaseManager {
    static  let firestoreDB = Firestore.firestore()
    static let firebaseStorage = Storage.storage()
    
    static func getPosts() async throws -> [PostType] {
        let querySnapshot = try await firestoreDB.collection("posts").getDocuments()
        var posts: [PostType] = []
        for document in querySnapshot.documents {
            let owner = document.data()["owner"] as? String ?? ""
            let imagename =  document.data()["imageName"] as? String ?? ""
            let imageURL = await FirebaseManager.getImageDownloadURL(id: imagename)
            let documentData = document.data()
            let post = PostType(postID: document.documentID,
                                postTitle: documentData["postTitle"] as? String ?? "",
                                owner: owner,
                                imageName: documentData["imageName"] as? String ?? "",
                                image: imageURL,
                                uploadTime: documentData["uploadTime"] as? Double ?? 0,
                                likes: documentData["likes"] as? [String] ?? []
            )
            posts.append(post)
        }
        return posts
    }
    
    static func likePost(postID: String, myEmailID: String) async throws {
        let postRef = firestoreDB.collection("posts").document(postID)
        try await postRef.updateData([
            "likes": FieldValue.arrayUnion([
                    myEmailID
            ])
        ])
    }

    static func dislikePost(postID: String, myEmailID: String) async throws {
        let postRef = firestoreDB.collection("posts").document(postID)
        try await postRef.updateData([
            "likes": FieldValue.arrayRemove([
                    myEmailID
            ])
        ])
    }

    static func getImageDownloadURL(id: String) async -> URL? {
        let postImage = firebaseStorage.reference().child("posts/\(id)")
        do {
            return try await postImage.downloadURL()
        } catch {
            print("err")
            return nil
        }
    }
    
    static func uploadImage(id: String, image: Data, owner: String, postTitle: String) async throws {
        let storageRef = firebaseStorage.reference().child("posts/\(id).jpg")
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            firestoreDB.collection("posts").addDocument(data: [
                "owner": owner,
                "postTitle": postTitle,
                "imageName": id + ".jpg",
                "uploadTime": Date().timeIntervalSince1970,
                "likes": [],
                "commnets": []
            ]) { err in
                if let err {
                    continuation.resume(throwing: err)
                }
                continuation.resume()
            }
        }
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            storageRef.putData(image) { storage, err in
                if let err {
                    continuation.resume(throwing: err)
                }
                continuation.resume()
            }
        }
    }
    
    static func sendMessage(to: (String, String) , from: (String, String), message: String) async throws {
        let senderDocRef = firestoreDB.collection("messages").document(from.0)
        let recieverDocRef = firestoreDB.collection("messages").document(to.0)
        
        try await senderDocRef.updateData([
            "\(to.1).messages": FieldValue.arrayUnion([
                [
                    "isOwner": true,
                    "content": message,
                    "time": Date().toMillis()!
                ]
            ])
        ])
        
        try await recieverDocRef.updateData([
            "\(from.1).messages": FieldValue.arrayUnion([
                [
                    "isOwner": false,
                    "content": message,
                    "time": Date().toMillis()!
                    
                ]
            ])
        ])
    }
    
    static func getProfile(email: String) async throws -> [String: String] {
        let querySnapshot = try await firestoreDB
            .collection("users")
            .document(email)
            .getDocument()
        
        if let data = querySnapshot.data(), let newData = data as? [String: String] {
            return newData
        } else {
            // TODO: Fix this throw an error
            return [:]
        }
    }
    
    static func createConversation(from: (String, String), to: (String, String)) async throws {
        try await firestoreDB.collection("messages").document(from.0).setData([
            to.1 : [
                "email": to.0,
                "messages": []
            ]], merge: true)
        
        try await firestoreDB.collection("messages").document(to.0).setData([
            from.1 : [
                "email": from.0,
                "messages": []
            ]], merge: true)
    }
    
    static func addDocumentListener(owner: String, onEvent: @escaping (_ querySnapshot: DocumentSnapshot?, _ err: Error?) -> Void) -> ListenerRegistration? {
        let listener = firestoreDB
            .collection("messages")
            .document(owner)
            .addSnapshotListener { querySnapshot, err in
                onEvent(querySnapshot, err)
            }
        return listener
    }
}
