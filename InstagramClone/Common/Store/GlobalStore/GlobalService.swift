//
//  GlobalService.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 29/09/23.
//

import FirebaseFirestore
import Foundation

struct GlobalProfileService {
    func getProfile(email: String,
                           _ dispatch: @escaping (_ action: GlobalAction) -> Void) {
        let firestoreDB = Firestore.firestore()
        firestoreDB
            .collection("users")
            .document(email)
            .getDocument { (querySnapshot, err) in
                if err != nil {
                    // TODO: Logout the user
                } else  {
                    if let data = querySnapshot?.data(), let newData = data as? [String: String] {
                        dispatch(.profileAction(.setProfile(newData["name"]!, newData["username"]!)))
                    }
                }
            }
    }
}

class GlobalMessageService {
     var listener: ListenerRegistration? = nil
     var selectedInfo: ((String, String), (String, String))? = nil
     var messagesFetchedOnce = true

     func removeListener() {
        if let listener {
            listener.remove()
        }
    }

     func addListener(owner: String, state: GlobalState, dispatch: @escaping (_ action: GlobalAction) -> Void){
        let firestoreDB = Firestore.firestore()
        guard listener != nil else {
            return
        }
        listener = firestoreDB
            .collection("messages")
            .document(owner)
            .addSnapshotListener { querySnapshot, err in
                if self.messagesFetchedOnce {
                    if err != nil {
                        dispatch(.messageAction(.setMessagesListStatus(.failure)))
                    } else  {
                        var messageListFormatted: [MessageListDetail] = []
                        var messages: [MessageDetail] = []
                        var lastMessage = ""
                        if let data = querySnapshot?.data()  {
                            for ownerName in data.keys {
                                messages = []
                                lastMessage = ""

                                let object = data[ownerName] as! [String: Any]

                                if let messagesExist = object["messages"] {
                                    for message in messagesExist  as! [[String: Any]] {
                                        messages.append(MessageDetail(isOwner: message["isOwner"] as! Bool, content: message["content"] as! String))
                                        lastMessage = message["content"] as! String
                                    }
                                }

                                if let email = object["email"]{
                                    messageListFormatted.append(MessageListDetail(ownerEmail: email as! String, ownerName: ownerName, content:lastMessage, message: messages))
                                }
                            }
                        }
                        print("HERE RUNNING LISTENER ", messageListFormatted)
                        dispatch(.messageAction(.setMessagesList(messageListFormatted)))
                        dispatch(.messageAction(.setMessagesListStatus(.success)))
                        if let selectedInfo = self.selectedInfo {
                            dispatch(.messageAction(.select(selectedInfo.0, selectedInfo.1)))
                        }
                    }
                }
            }
    }

    func selectMessage(state : GlobalState, from: (String,String), to:(String,String) , dispatch : @escaping (_ action : GlobalAction) -> Void ){
        var isConversationAvailable = false
        selectedInfo = (from, to)
        state.messageState.messageList.forEach({ message in
            if message.ownerName == from.1 {
                DispatchQueue.main.async {
                    dispatch(.messageAction(.setMessages(message.message)))
                }
                isConversationAvailable = true
            }
        })

        guard isConversationAvailable else {
            createConversation(from: from, to: to)
            return
        }
    }

     func createConversation(from: (String, String), to: (String, String)) {
        let firestoreDB = Firestore.firestore()
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
    
     func reset() {
        self.selectedInfo = nil
    }
}
