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

    static func getPosts(completionHandler: @escaping (_ documents: [QueryDocumentSnapshot]) async -> Void) async {
        do {
            let querySnapshot = try await firestoreDB.collection("posts").getDocuments()
            await completionHandler(querySnapshot.documents)
        } catch {
            print("Err")
        }

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

    static func uploadImage(id: String, image: Data, owner: String, postTitle: String) {
        let storageRef = firebaseStorage.reference().child("posts/\(id).jpg")
        let postDocRef = firestoreDB.collection("posts").addDocument(data: [
            "owner": owner,
            "postTitle": postTitle,
            "imageName": id + ".jpg"
        ]) { err in
            if let err {
                print("An error occurred", err)
            }
            print("Document Created successfully. ")
        }


        storageRef.putData(image) { storage, err in
            if let err {
                print("Error occured", err)
                return
            }
            print("Image Uploaded successfully.")
        }
    }

    static func sendMessage(to: (String, String) , from: (String, String), message: String) {
        let senderDocRef = firestoreDB.collection("messages").document(from.0)
        let recieverDocRef = firestoreDB.collection("messages").document(to.0)

        senderDocRef.updateData([
            "\(to.1).messages": FieldValue.arrayUnion([
                [
                    "isOwner": true,
                    "content": message,
                    "time": Date().toMillis()!
                ]
            ])
        ])

        recieverDocRef.updateData([
            "\(from.1).messages": FieldValue.arrayUnion([
                [
                    "isOwner": false,
                    "content": message,
                    "time": Date().toMillis()!

                ]
            ])
        ])
    }

    static func getProfile(email: String, success: @escaping (_ newData: [String: String]) -> Void, err: @escaping () -> Void) {
        firestoreDB
            .collection("users")
            .document(email)
            .getDocument { querySnapshot, err in
                if err == nil {
                    if let data = querySnapshot?.data(), let newData = data as? [String: String] {
                        success(newData)
                    }
                } else  {
                    // TODO: Fix
                    //err()
                }
            }
    }

    static func createConversation(from: (String, String), to: (String, String)) {
        firestoreDB.collection("messages").document(from.0).setData([
            to.1 : [
                "email": to.0,
                "messages": []
            ]], merge: true)

        firestoreDB.collection("messages").document(to.0).setData([
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
