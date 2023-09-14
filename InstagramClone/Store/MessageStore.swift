//
//  MessageStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import Foundation
import FirebaseFirestore

struct MessageDetail  : Codable {
    var isOwner : Bool;
    var content : String ;
}

struct MessageListDetail {
    var ownerName : String;
    var content: String ;
    var message :  [MessageDetail]
}

struct MessageState {
    var selectedMessage : [MessageDetail] = [];
    
    var messageListStatus : AsyncStatus  = .inital;
    var messageList : [MessageListDetail] = [];
}

enum MessageAction {
    case send(String, String,String)
    case select(String,String)
    case recieveAll(String)
    
    case resetMessages
    case setMessages([MessageDetail])
    case setMessagesList([MessageListDetail])
    case setMessagesListStatus(AsyncStatus)
}


class MessageService {
    static var listener : ListenerRegistration? = nil;
    
    static func addListener(owner : String , dispatch: @escaping (_ action: MessageAction) -> Void){
        let firestoreDB = Firestore.firestore()
        print(owner, "HERE")
        listener = firestoreDB.collection("messages").document(owner)
            .addSnapshotListener(includeMetadataChanges: true) { querySnapshot, err in
                if let err {
                    print("An err occurred while retrieving")
                    dispatch(.setMessagesListStatus(.failure))
                } else  {
                    let source = querySnapshot!.metadata.hasPendingWrites ? "Local" : "Server"
                    print("\(source) data: \(querySnapshot!.data()! ?? [:])")
                    var messageListFormatted : [MessageListDetail] = []
                    var messages : [MessageDetail] = []
                    var lastMessage = ""
                    if let data = querySnapshot?.data()  {
                        print(data)
                        for ownerName in data.keys {
                            print(ownerName)
                            for message in data[ownerName]!  as! [[String:Any]] {
                                messages.append(MessageDetail(isOwner: message["isOwner"] as! Bool, content: message["content"] as! String))
                                lastMessage = message["content"] as! String
                            }
                            messageListFormatted.append(MessageListDetail(ownerName: ownerName, content:lastMessage , message: messages ))
                        }
                    }
                    print("MessageListFormatted ",messageListFormatted)
                    dispatch(.setMessagesList(messageListFormatted))
                    dispatch(.setMessagesListStatus(.success))
                }
            }
    }
    
    static func sendMessage(to :String , from : String, message :String)  {
        let firestoreDB = Firestore.firestore()
        print(to, from)
        let senderDocRef = firestoreDB.collection("messages").document(from);
        let recieverDocRef = firestoreDB.collection("messages").document(to);
        
        senderDocRef.updateData([
            to: FieldValue.arrayUnion([
                [
                    "isOwner" : true,
                    "content" : message
                ]
            ])
        ])
        
        recieverDocRef.updateData([
          from  : FieldValue.arrayUnion([
                [
                    "isOwner" : false,
                    "content" : message
                ]
            ])
        ])
    }
    
    static func selectMessage( state : MessageState, from: String, to:String , dispatch : @escaping (_ action : MessageAction) -> Void ){
        var isConversationAvailable = false ;
        state.messageList.forEach({ message in
            if message.ownerName == from {
                dispatch(.setMessages(message.message))
                isConversationAvailable = true;
            }
        })
        if !isConversationAvailable {
            let firestoreDB = Firestore.firestore()
            firestoreDB.collection("messages").document(from).setData([ to : []], merge: true)
            firestoreDB.collection("messages").document(to).setData([ from : []], merge: true)
        }
    }
    
    static func recieveList(currentUser : String , dispatch: @escaping (_ action : MessageAction ) -> Void ) {
        let firestoreDB = Firestore.firestore()
        print("HERE")
        firestoreDB.collection("messages").document(currentUser).getDocument { (querySnapshot , err) in
            if let err {
                print("An err occurred while retrieving")
                dispatch(.setMessagesListStatus(.failure))
            } else  {
                var messageListFormatted : [MessageListDetail] = []
                var messages : [MessageDetail] = []
                var lastMessage = ""
                if let data = querySnapshot?.data()  {
                    for ownerName in data.keys {
                        print(data[ownerName]!)
                        for message in data[ownerName]!  as! [[String:Any]] {
                            messages.append(MessageDetail(isOwner: message["isOwner"] as! Bool, content: message["content"] as! String))
                            lastMessage = message["content"] as! String
                        }
                        messageListFormatted.append(MessageListDetail(ownerName: ownerName, content:lastMessage , message: messages ))
                    }
                }
                print("MessageListFormatted ",messageListFormatted)
                dispatch(.setMessagesList(messageListFormatted))
                dispatch(.setMessagesListStatus(.success))
            }
        }
    }
}

class MessageStore : ObservableObject {
    @Published var state : MessageState ;
    
    init(state: MessageState = MessageState()) {
        self.state = state;
    }
    
    func dispatch(_ action : MessageAction) {
        self.state = self.reducer(self.state, action)
    }
    
    func reducer(_ state : MessageState , _ action : MessageAction ) -> MessageState {
        var mutableState = state;
        switch action  {
        case .send(let to, let from , let message):
            MessageService.sendMessage(to: to,from : from,  message: message)
        case .recieveAll(let from):
            mutableState.messageListStatus = .pending
            MessageService.recieveList(currentUser: from,dispatch:  self.dispatch)
        case .select(let from , let to):
            MessageService.selectMessage(state:state,from: from, to: to , dispatch: self.dispatch)
            
        case .resetMessages :
            mutableState.selectedMessage = [];
        case .setMessages(let message):
            mutableState.selectedMessage = message
        case .setMessagesList(let messageList):
            mutableState.messageList = messageList
        case .setMessagesListStatus(let messageListStatus):
            print("Changing state ", messageListStatus)
            mutableState.messageListStatus = messageListStatus ;
        }
        return mutableState;
    }
    
}
