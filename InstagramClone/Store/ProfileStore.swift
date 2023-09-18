//
//  ProfileStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import Foundation
import FirebaseFirestore

struct ProfileState {
    var email : String;
    var username : String
    var profilePicture  :String {
        return Constant.getImageUrl(title: username)
    }
}

enum ProfileAction {
    case getProfile(String)
    case setProfile(String,String)
}

struct ProfileService {
    static func getProfile(email : String, _ dispatch : @escaping (_ action : ProfileAction) -> Void ) {
        let firestoreDB = Firestore.firestore()
        firestoreDB.collection("users").document(email).getDocument { (querySnapshot , err) in
            if let err {
                //   dispatch(.setMessagesListStatus(.failure))
            } else  {
                if let data = querySnapshot?.data()  {
                    let newData = data  as! [String: String] ;
                    dispatch(.setProfile(newData["name"]!, newData["username"]!))
                    //messageListFormatted.append(MessageListDetail(ownerEmail :email as! String,ownerName: ownerName, content:lastMessage , message: messages ))
                }
            }
        }
    }
}



class ProfileStore : ObservableObject {
    @Published var state  : ProfileState ;
    
    init (state : ProfileState = ProfileState(email: "", username:  "")) {
        self.state = state ;
    }
    
    func dispatch(_ action : ProfileAction) {
        self.state = self.reducer(self.state ,action)
    }
    
    func reducer(_ state : ProfileState , _ action : ProfileAction )  ->  ProfileState {
        var mutableState = state ;
        switch action {
        case .getProfile(let email):
            ProfileService.getProfile(email: email, self.dispatch)
            
        case .setProfile(let email, let username) :
            mutableState.email = email;
            mutableState.username = username;
        }
        return mutableState ;
    }
}
