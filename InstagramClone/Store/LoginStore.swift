//
//  LoginStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 06/09/23.
//

import Foundation
import FirebaseAuth

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
    static func signup(email: String, password : String ,_ dispatch :@escaping (_ action :AuthAction)-> Void)  {
        dispatch(.setSignupStatus(.pending))
        Auth.auth().createUser(withEmail: email, password: password) { authResult ,error in
            if let _ = authResult {
                dispatch( .setSignupStatus(.success))
            } else if let error {
                dispatch( .setSignupStatus(.failure(error.localizedDescription)))
            } else {
                dispatch( .setSignupStatus(.failure("Something went wrong.")))
            }
        }
    }
    static func  login(email: String, password : String ,_ dispatch :@escaping (_ action :AuthAction)-> Void) {
        dispatch(.setLoginStatus(.pending))
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error  in
            if let authResult {
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
        let newState = self.reducer(self.state, action)
        state = newState
    }
    
    func reducer (_ state : AuthState, _ action : AuthAction) -> AuthState {
        var mutableState = state;
        switch action {
        case .login :
            AuthService.login(email: state.email, password: state.password,self.dispatch)
        case .signup:
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

