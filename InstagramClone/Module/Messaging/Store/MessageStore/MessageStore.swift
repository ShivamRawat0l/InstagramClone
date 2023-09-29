//
//  MessageStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import Foundation

class MessageStore: ObservableObject {
    @Published var state: MessageState

    var messageService = MessageService()

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
            messageService.sendMessage(to: to, from: from, message: message)
        }
        
        return mutableState;
    }
}
