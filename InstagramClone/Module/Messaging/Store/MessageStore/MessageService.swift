//
//  MessageService.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 29/09/23.
//

import Foundation
import FirebaseFirestore

class MessageService {
    /*
     This method sends the message from one user to another and create the message object for both user.

     - parameter to: Indicates the person sending the message. Its is a tuple (email, username) with first argument as email and second as username
     - parameter from: Indicates the person the message is being send to. Its is a tuple (email, username) with first argument as email and second as username
     */
    func sendMessage(to: (String, String) , from: (String, String), message: String)  {
        let firestoreDB = Firestore.firestore()
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
}
