//
//  MessageStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import Foundation

struct MessageState {
    var messages : [String];
}

enum MessageAction {
    case send(String, String)
    case recieve(String)
}


class MessageService {
    
}

class MessageStore : ObservableObject {
    var state : MessageState ;
    
    func dispatch(_ action : MessageAction) {
        
    }
    
    func reducer(_ state : MessageState , _ action : MessageAction ) {
        
    }
    
}
