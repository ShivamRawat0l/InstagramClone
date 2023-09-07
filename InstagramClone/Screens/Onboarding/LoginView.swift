//
//  LoginView.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 05/09/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authStore : AuthStore ;
    var body: some View {
        VStack {
            NavigationLink(destination: Homescreen() , isActive: .constant(authStore.state.loginAuthStatus == AuthStatus.success)) {
                EmptyView()
            }
            TextField("Enter your email address", text: $authStore.state.email)
            TextField("Enter your password", text: $authStore.state.password)
            switch  authStore.state.loginAuthStatus {
            case .initial :
                Text("Initial")
            case .pending:
                Text("Pending")
            case .failure(let err):
                Text("\(err)")
            default :
                Text("Unknown Error")
            }
            if case .failure(let error) = authStore.state.loginAuthStatus {
                Text(error)
            }
            Button {
                authStore.dispatch(.login)
            } label : {
                Text("Sign In" )
                
            }
            NavigationLink(isActive: .constant(true)) {
                SignupView();
            } label : {
                Text("Create Account")
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
