//
//  AuthState.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 29/09/23.
//

import Foundation

enum AuthStatus: Equatable {
    case initial
    case pending
    case failure(String)
    case success(String)
}

struct AuthState: Equatable {
    var username = ""
    var email = ""
    var password = ""
    var loginAuthStatus: AuthStatus = .initial
    var signupAuthStatus: AuthStatus = .initial
}
