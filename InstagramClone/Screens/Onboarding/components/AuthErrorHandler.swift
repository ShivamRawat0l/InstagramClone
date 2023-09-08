//
//  AuthErrorHandler.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 07/09/23.
//

import SwiftUI

struct AuthErrorHandler: View {
    var authStatus : AuthStatus ;
    var body: some View {
        switch  authStatus {
        case .initial :
            EmptyView()
        case .pending:
            Text("Pending")
        case .failure(let err):
            Text("\(err)")
        default :
            Text("Unknown Error")
        }
    }
}

#Preview {
    AuthErrorHandler(authStatus: .initial)
}
