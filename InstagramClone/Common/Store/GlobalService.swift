//
//  GlobalService.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 29/09/23.
//

import FirebaseFirestore
import Foundation

struct GlobalProfileService {
    func getProfile(email: String) async throws -> (String, String) {
        let newData = try await FirebaseManager.getProfile(email: email)
        return (newData["name"]!, newData["username"]!)
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

    func getFormattedMessages(querySnapshot: DocumentSnapshot?) -> [MessageListDetail] {
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
        return messageListFormatted
    }

    func addListener(owner: String, state: GlobalState, dispatch: @escaping (_ action: GlobalAction) -> Void){
        guard listener == nil else {
            return
        }
        listener = FirebaseManager.addDocumentListener(owner: owner) { querySnapshot, err in
                if self.messagesFetchedOnce {
                    if err != nil {
                        dispatch(.messageAction(.setMessagesListStatus(.failure)))
                    } else  {
                        let messageListFormatted = self.getFormattedMessages(querySnapshot: querySnapshot)
                        dispatch(.messageAction(.setMessagesList(messageListFormatted)))
                        dispatch(.messageAction(.setMessagesListStatus(.success)))
                        if let selectedInfo = self.selectedInfo {
                            dispatch(.messageAction(.selectUserMessage(selectedInfo.0, selectedInfo.1)))
                        }
                    }
                }
            }
    }

    func selectMessage(state : GlobalState, from: (String,String), to:(String,String)) async throws -> [MessageDetail] {
        var isConversationAvailable = false
        var selectedConversation: [MessageDetail] = []
        selectedInfo = (from, to)
        state.messageState.messageList.forEach({ message in
            if message.ownerName == from.1 {
                selectedConversation = message.message
                isConversationAvailable = true
            }
        })

        guard isConversationAvailable else {
            try await createConversation(from: from, to: to)
            // TODO: Replace with proper error
            throw URLError(.badURL)
        }
        return selectedConversation
    }

    func createConversation(from: (String, String), to: (String, String)) async throws {
        try await FirebaseManager.createConversation(from: from, to: to)
    }

    func reset() {
        self.selectedInfo = nil
    }
}
