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

@MainActor class AuthStore: ObservableObject {

    @Published var state: AuthState
    var authService: AuthService

    init(state: AuthState = AuthState(), authService: AuthService = AuthService()) {
        self.state = state
        self.authService = authService
    }

    func dispatch(_ action: AuthAction) {
        state = self.reducer(self.state, action)
    }

    func reducer (_ state: AuthState, _ action: AuthAction) -> AuthState {
        var mutableState = state
        switch action {
        case .didTapOnLogin:
            Task {
                do {
                    mutableState.loginAuthStatus = .pending
                    let email = try await authService.login(email: state.email, password: state.password)
                    self.dispatch(.setLoginStatus(.success(email)))
                } catch {
                    // TODO: Handle Error
                }
            }
        case .didTapOnSignup:
            Task {
                do {
                    mutableState.signupAuthStatus = .pending
                    let email = try await authService.signup(username: state.username,
                                                         email: state.email,
                                                         password: state.password)
                    self.dispatch(.setSignupStatus(.success(email)))
                } catch {
                    // TODO: Handle error
                }
            }
            // MARK: Setter actions
        case .reset:
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

