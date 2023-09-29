//
//  MessageStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import FirebaseFirestore
import Foundation

struct MessageDetail: Codable {
    var isOwner: Bool
    var content: String
}

struct MessageListDetail {
    var ownerEmail: String
    var ownerName: String
    var content: String
    var message: [MessageDetail]
}

enum MessageAction {
    case send((String, String), (String, String), String)
}

class MessageService {
    /*
     This method sends the message from one user to another and create the message object for both user.

     - parameter to: Indicates the person sending the message. Its is a tuple (email, username) with first argument as email and second as username
     - parameter from: Indicates the person the message is being send to. Its is a tuple (email, username) with first argument as email and second as username
     */
    static func sendMessage(to: (String, String) , from: (String, String), message: String)  {
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

class MessageStore: ObservableObject {
    @Published var state: MessageState

    init(state: MessageState = MessageState()) {
        self.state = state
    }

    func dispatch(_ action: MessageAction) {
        self.state = self.reducer(self.state, action)
    }

    func reducer(_ state: MessageState, _ action: MessageAction) -> MessageState {
        let mutableState = state;

        switch action {
        case .send(let to, let from , let message):
            MessageService.sendMessage(to: to, from: from, message: message)
        }

        return mutableState;
    }
}
