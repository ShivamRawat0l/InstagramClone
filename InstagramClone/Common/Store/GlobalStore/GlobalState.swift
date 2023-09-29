//
//  GlobalState.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 29/09/23.
//

import Foundation

struct ProfileState {
    var email = ""
    var username = ""
    var profilePicture: String {
        return Constant.getImageUrl(title: username)
    }
}

struct MessageState {
    var selectedMessage: [MessageDetail] = []
    var messageListStatus: AsyncStatus  = .inital
    var messageList: [MessageListDetail] = []
}

struct GlobalState {
    var loginStatus : LoginStatus = .initial
    var profileState: ProfileState = ProfileState()
    var messageState: MessageState = MessageState()
}
