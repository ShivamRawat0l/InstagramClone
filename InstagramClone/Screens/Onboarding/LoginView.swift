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
            InstagramLogo()
                .padding()
            TextField("Enter your email address", text: $authStore.state.email)
            TextField("Enter your password", text: $authStore.state.password)
            AuthErrorHandler(authStatus: authStore.state.loginAuthStatus)
            
            Button {
                authStore.dispatch(.login)
            } label : {
                PrimaryButton(text: "Login", loading: authStore.state.loginAuthStatus == .pending)
            }
            Spacer()
            NavigationLink {
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
        .environmentObject(AuthStore())
}
