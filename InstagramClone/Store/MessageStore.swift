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
    var ownerEmail : String;
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
    case send((String,String), (String,String),String)
    case select((String,String),(String,String))
    case recieveAll(String)
    case addListeners(String)
    
    case resetMessages
    case setMessages([MessageDetail])
    case setMessagesList([MessageListDetail])
    case setMessagesListStatus(AsyncStatus)
}


class MessageService {
    static var listener : ListenerRegistration? = nil;
    static var selectedInfo: ((String,String),(String,String))? = nil ;
    
    static func addListener(owner : String , state : MessageState,dispatch: @escaping (_ action: MessageAction) -> Void){
        let firestoreDB = Firestore.firestore()
        print(owner, "ADDDING LISTENER")
        listener = firestoreDB.collection("messages").document(owner)
            .addSnapshotListener(includeMetadataChanges: true) { querySnapshot, err in
                print("RUNNING SNAPSHOT",state.messageListStatus , selectedInfo)
                if let err {
                    dispatch(.setMessagesListStatus(.failure))
                } else  {
                    var messageListFormatted : [MessageListDetail] = []
                    var messages : [MessageDetail] = []
                    var lastMessage = ""
                    if let data = querySnapshot?.data()  {
                        for ownerName in data.keys {
                            let object = data[ownerName] as! [ String : Any ]
                            if let messagesExist = object["messages"] {
                                for message in messagesExist  as! [[String:Any]] {
                                    messages.append(MessageDetail(isOwner: message["isOwner"] as! Bool, content: message["content"] as! String))
                                    lastMessage = message["content"] as! String
                                }
                            }
                            if let email = object["email"]{
                                messageListFormatted.append(MessageListDetail(ownerEmail :email as! String,ownerName: ownerName, content:lastMessage , message: messages ))
                            }
                        }
                    }
                    dispatch(.setMessagesList(messageListFormatted))
                    dispatch(.setMessagesListStatus(.success))
                    if let selectedInfo {
                        dispatch(.select(selectedInfo.0, selectedInfo.1))
                    }
                }
            }
    }
    
    static func sendMessage(to :(String,String) , from : (String,String), message :String)  {
        let firestoreDB = Firestore.firestore()
        let senderDocRef = firestoreDB.collection("messages").document(from.0);
        let recieverDocRef = firestoreDB.collection("messages").document(to.0);
        
        senderDocRef.updateData([
            "\(to.1).messages":FieldValue.arrayUnion([
                [
                    "isOwner" : true,
                    "content" : message
                ]
            ])
            
        ])
        
        recieverDocRef.updateData([
            "\(from.1).messages"  :FieldValue.arrayUnion([
                [
                    "isOwner" : false,
                    "content" : message
                ]
            ])
            
        ])
    }
    
    static func createConversation(from: (String,String), to:(String,String)  ){
     
            let firestoreDB = Firestore.firestore()
            firestoreDB.collection("messages").document(from.0).setData([ to.1 : [
                "email"  : from.0,
                "messages": []
            ]], merge: true)
            firestoreDB.collection("messages").document(to.0).setData([ from.1 : [
                "email"  : to.0,
                "messages": []
            ]], merge: true)
        
    }
    
    static func selectMessage( state : MessageState, from: (String,String), to:(String,String) , dispatch : @escaping (_ action : MessageAction) -> Void ){
        var isConversationAvailable = false ;
        selectedInfo = (from, to) ;
        state.messageList.forEach({ message in
            if message.ownerName == from.1 {
                DispatchQueue.main.async {
                    dispatch(.setMessages(message.message))
                }
                isConversationAvailable = true;
            }
        })
        if !isConversationAvailable {
           createConversation(from: from, to: to)
        }
    }
    
    static func recieveList(currentUser : String , dispatch: @escaping (_ action : MessageAction ) -> Void ) {
        let firestoreDB = Firestore.firestore()
        firestoreDB.collection("messages").document(currentUser).getDocument { (querySnapshot , err) in
            if let err {
                dispatch(.setMessagesListStatus(.failure))
            } else  {
                var messageListFormatted : [MessageListDetail] = []
                var messages : [MessageDetail] = []
                var lastMessage = ""
                if let data = querySnapshot?.data()  {
                    for ownerName in data.keys {
                        let object = data[ownerName] as! [ String : Any ]
                        if let messagesExist = object["messages"] {
                            for message in messagesExist  as! [[String:Any]] {
                                messages.append(MessageDetail(isOwner: message["isOwner"] as! Bool, content: message["content"] as! String))
                                lastMessage = message["content"] as! String
                            }
                        }
                        if let email = object["email"]{
                            messageListFormatted.append(MessageListDetail(ownerEmail :email as! String,ownerName: ownerName, content:lastMessage , message: messages ))
                        }
                    }
                }
                dispatch(.setMessagesList(messageListFormatted))
                dispatch(.setMessagesListStatus(.success))
            }
        }
    }
    
    static func reset() {
        self.selectedInfo = nil ;
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
            MessageService.selectMessage(state:self.state,from: from, to: to , dispatch: self.dispatch)
        case .addListeners(let owner):
            MessageService.addListener(owner: owner, state :state, dispatch: self.dispatch)
            
        case .resetMessages :
            mutableState.selectedMessage = [];
            MessageService.reset()
        case .setMessages(let message):
            mutableState.selectedMessage = message
        case .setMessagesList(let messageList):
            mutableState.messageList = messageList
        case .setMessagesListStatus(let messageListStatus):
            mutableState.messageListStatus = messageListStatus ;
        }
        return mutableState;
    }
    
}
