//
//  FirebaseManager.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 29/09/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class FirebaseManager {
    static  let firestoreDB = Firestore.firestore()

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
