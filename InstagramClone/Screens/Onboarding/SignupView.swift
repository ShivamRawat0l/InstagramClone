//
//  SignupView.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 06/09/23.
//

import Foundation
import SwiftUI

struct SignupView : View {
    @EnvironmentObject var authStore : AuthStore ;
    @Environment(\.dismiss) var dismiss;
    var body: some View {
        NavigationLink(destination: HomeScreen() , isActive: .constant(authStore.state.signupAuthStatus == AuthStatus.success)) {
            EmptyView()
        }
        VStack {
            TextField("Enter your username", text: $authStore.state.username)
                .autocorrectionDisabled(true)
                .defaultInput()
                .padding(.top, 20)
            TextField("Enter your email address", text: $authStore.state.email)
                .autocorrectionDisabled(true)
                .defaultInput()
                .padding(.top, 20)
            PasswordField(title:"Enter your password", text: $authStore.state.password)
                .padding(.top, 20)
            AuthErrorHandler(authStatus: authStore.state.signupAuthStatus)
                .foregroundColor(.red)
                .padding(.top, 20)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity,alignment: .leading)
            Button {
                authStore.dispatch(.signup)
            } label : {
                PrimaryButton(text: "Create Account")
                    .padding(.top, 100)
            }
            Spacer()
            Button {
                dismiss();
            } label : {
                Text("Sign In")
            }
        }
        .navigationTitle("New Account")
        .navigationBarTitleDisplayMode(.large)
        .padding()
    }
}

#Preview {
    SignupView()
        .environmentObject(AuthStore(state: AuthState(username: "",email: "", password: "", loginAuthStatus: .failure("Erro"), signupAuthStatus: .failure("Error"))))
}
