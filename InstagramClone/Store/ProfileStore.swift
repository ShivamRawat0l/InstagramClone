//
//  ProfileStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import Foundation
import FirebaseFirestore

struct ProfileState {
    var email = ""
    var username = ""
    var profilePicture: String {
        return Constant.getImageUrl(title: username)
    }
}

enum ProfileAction {
    case getProfile(String)
    
    // MARK: Setter actions
    case setProfile(String, String)
}

struct ProfileService {
    static func getProfile(email: String,
                           _ dispatch: @escaping (_ action: ProfileAction) -> Void) {
        let firestoreDB = Firestore.firestore()
        firestoreDB
            .collection("users")
            .document(email)
            .getDocument { (querySnapshot, err) in
                if err != nil {
                    // TODO: Logout the user
                } else  {
                    if let data = querySnapshot?.data(), let newData = data as? [String: String] {
                        dispatch(.setProfile(newData["name"]!, newData["username"]!))
                    }
                }
            }
    }
}



class ProfileStore: ObservableObject {
    @Published var state: ProfileState
    
    init (state: ProfileState = ProfileState()) {
        self.state = state
    }
    
    func dispatch(_ action: ProfileAction) {
        self.state = self.reducer(self.state, action)
    }
    
    func reducer(_ state: ProfileState,
                 _ action: ProfileAction) -> ProfileState {
        
        var mutableState = state
        
        switch action {
        case .getProfile(let email):
            ProfileService.getProfile(email: email, self.dispatch)

            // MARK: Setter actions
        case .setProfile(let email, let username):
            mutableState.email = email
            mutableState.username = username
        }
        
        return mutableState ;
    }
}
