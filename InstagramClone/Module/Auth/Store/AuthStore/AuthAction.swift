//
//  AuthAction.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 29/09/23.
//

import Foundation

enum AuthAction {
    case login
    case signup

    // MARK: Setter actions
    case reset
    case setLoginStatus(AuthStatus)
    case setSignupStatus(AuthStatus)
}
