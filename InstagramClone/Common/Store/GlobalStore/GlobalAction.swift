//
//  GlobalAction.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 29/09/23.
//

import Foundation

enum GlobalAuthAction {
    case login(String, LoginStatus)
    case reset
}

enum GlobalProfileAction {
    case getProfile(String)

    // MARK: Setter actions
    case setProfile(String, String)
}

enum GlobalMessageAction {
    case select((String, String),(String, String))
    case addListeners(String)

    // MARK: Setter Actions
    case resetMessages
    case setMessages([MessageDetail])
    case setMessagesList([MessageListDetail])
    case setMessagesListStatus(AsyncStatus)
}

enum GlobalAction {
    case messageAction(GlobalMessageAction)
    case profileAction(GlobalProfileAction)
    case authAction(GlobalAuthAction)
}
