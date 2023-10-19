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
    func sendMessage(to: (String, String) , from: (String, String), message: String) async throws {
        try await FirebaseManager.sendMessage(to: to, from: from, message: message)
    }
}
