//
//  LoginStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 06/09/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

typealias ReducerType = (_ state : AuthState , _ action :AuthAction) -> AuthState ;

enum AuthAction {
    case login
    case signup
    case reset
    case setLoginStatus(AuthStatus)
    case setSignupStatus(AuthStatus)
}

enum AuthStatus : Equatable {
    case initial;
    case pending;
    case failure(String);
    case success;
}

struct AuthState  {
    var email : String ;
    var password : String ;
    var loginAuthStatus : AuthStatus;
    var signupAuthStatus: AuthStatus;
}

struct AuthService {
    
    static func createUser(email :String) {
        let firestoreDB = Firestore.firestore();
        
        firestoreDB.collection("users").document(email).setData([
            "name" : email
        ])  { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    static func signup(email: String, password : String ,_ dispatch :@escaping (_ action :AuthAction)-> Void)  {
        Auth.auth().createUser(withEmail: email, password: password) { authResult ,error in
            if let _ = authResult {
                createUser(email: email)
                dispatch( .setSignupStatus(.success))
            } else if let error {
                dispatch( .setSignupStatus(.failure(error.localizedDescription)))
            } else {
                dispatch( .setSignupStatus(.failure("Something went wrong.")))
            }
        }
    }
    static func  login(email: String, password : String ,_ dispatch :@escaping (_ action :AuthAction)-> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error  in
            if let authResult {
                createUser(email: email)
                dispatch(.setLoginStatus(.success))
            } else  if let error {
                dispatch(.setLoginStatus(.failure(error.localizedDescription)))
            } else {
                dispatch(.setLoginStatus(.failure("Something went wrong.")))
            }
        }
    }
}



@MainActor class AuthStore : ObservableObject{
    @Published var state : AuthState;
    
    init(state: AuthState = AuthState(email: "", password: "", loginAuthStatus: .initial, signupAuthStatus: .initial)) {
        self.state = state
    }
    
    func dispatch( _ action:AuthAction ){
        state = self.reducer(self.state, action)
    }
    
    func reducer (_ state : AuthState, _ action : AuthAction) -> AuthState {
        var mutableState = state;
        switch action {
        case .login :
            mutableState.loginAuthStatus = .pending
            AuthService.login(email: state.email, password: state.password,self.dispatch)
        case .signup:
            mutableState.signupAuthStatus = .pending
            AuthService.signup(email: state.email, password: state.password,self.dispatch)
        case .reset :
            mutableState.email = ""
            mutableState.password = ""
            mutableState.loginAuthStatus = .initial
            mutableState.signupAuthStatus = .initial
        case .setLoginStatus(let status):
            mutableState.loginAuthStatus = status
        case .setSignupStatus(let status):
            mutableState.signupAuthStatus = status
        }
        return mutableState;
    }
}

