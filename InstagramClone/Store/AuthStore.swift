//
//  LoginStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 06/09/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

typealias ReducerType = (_ state: AuthState , _ action: AuthAction) -> AuthState

enum AuthAction {
    case login
    case signup
    case reset
    case setLoginStatus(AuthStatus)
    case setSignupStatus(AuthStatus)
}

enum AuthStatus: Equatable {
    case initial
    case pending
    case failure(String)
    case success(String)
}

struct AuthState: Equatable {
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var loginAuthStatus: AuthStatus = .initial
    var signupAuthStatus: AuthStatus = .initial
}

struct AuthService {

    static func createUser(username: String, email: String) {
        let firestoreDB = Firestore.firestore();

        firestoreDB.collection("users").document(email).setData([
            "name": email,
            "username": username + String(email.hash)
        ])  { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }

    static func signup(username: String,
                       email: String,
                       password: String,
                       _ dispatch: @escaping (_ action: AuthAction)-> Void)  {
        Auth
            .auth()
            .createUser(withEmail: email, password: password) { authResult ,error in

                if let _ = authResult {
                    createUser(username: username, email: email)
                    dispatch( .setSignupStatus(.success(email)))
                    dispatch( .setLoginStatus(.success(email)))
                } else if let error {
                    dispatch( .setSignupStatus(.failure(error.localizedDescription)))
                } else {
                    dispatch( .setSignupStatus(.failure("Something went wrong.")))
                }
            }
    }

    static func  login(email: String,
                       password: String ,
                       _ dispatch: @escaping (_ action: AuthAction) -> Void) {

        Auth
            .auth()
            .signIn(withEmail: email, password: password) { authResult, error  in

                if authResult != nil {
                    dispatch(.setLoginStatus(.success(email)))
                } else  if let error {
                    dispatch(.setLoginStatus(.failure(error.localizedDescription)))
                } else {
                    dispatch(.setLoginStatus(.failure("Something went wrong.")))
                }

            }

    }
}



@MainActor class AuthStore : ObservableObject{
    @Published  var state = AuthState();

    @AppStorage("AuthStatus") var authStatus = "";

    init(state: AuthState = AuthState()) {
        self.state = state
        if authStatus != "" {
            self.state.email = authStatus;
            self.state.loginAuthStatus = .success(authStatus)
        }
    }

    func dispatch(_ action: AuthAction) {
        state = self.reducer(self.state, action)
    }

    func reducer (_ state: AuthState, _ action: AuthAction) -> AuthState {
        var mutableState = state;
        switch action {
        case .login:
            mutableState.loginAuthStatus = .pending
            AuthService.login(email: state.email,
                              password: state.password,
                              self.dispatch)
        case .signup:
            mutableState.signupAuthStatus = .pending
            AuthService.signup(username: state.username,
                               email: state.email,
                               password: state.password,self.dispatch)
        case .reset:
            mutableState.email = ""
            mutableState.password = ""
            mutableState.loginAuthStatus = .initial
            mutableState.signupAuthStatus = .initial
        case .setLoginStatus(let status):
            switch status {
            case .success(let email):
                self.authStatus = email
            case .failure, .initial, .pending:
                self.authStatus = ""
            }
            mutableState.loginAuthStatus = status
        case .setSignupStatus(let status):
            mutableState.signupAuthStatus = status
        }
        return mutableState;
    }
}

