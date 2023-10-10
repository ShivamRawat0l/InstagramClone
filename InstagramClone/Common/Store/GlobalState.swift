//
//  GlobalState.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 29/09/23.
//

import Foundation

enum LoginStatus: Equatable {
    case initial
    case pending
    case failure
    case success
}

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

struct GlobalProfileState {
    var email = ""
    var username = ""
    var profilePicture: String {
        return Constant.getImageUrl(title: username)
    }
}

struct GlobalMessageState {
    var selectedMessage: [MessageDetail] = []
    var messageListStatus: AsyncStatus  = .inital
    var messageList: [MessageListDetail] = []
}

struct GlobalState {
    var loginStatus : LoginStatus = .initial
    var profileState: GlobalProfileState = GlobalProfileState()
    var messageState: GlobalMessageState = GlobalMessageState()
}
