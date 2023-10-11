//
//  SignupView.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 06/09/23.
//

import Foundation
import SwiftUI

struct SignupView : View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var globalStore: GlobalStore
    @StateObject var authStore = AuthStore()

    private func inputFields() -> some View {
        VStack {
            TextField("Enter your username", text: $authStore.state.username)
                .textFieldStyle(DefaultInputStyle())
            TextField("Enter your email address", text: $authStore.state.email)
                .textFieldStyle(DefaultInputStyle())
            PasswordField(title: "Enter your password", text: $authStore.state.password)
        }
        .padding(.top, 20)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
    }

    var body: some View {
        VStack {
            inputFields()
            AuthErrorHandler(authStatus: authStore.state.signupAuthStatus)
                .foregroundColor(.red)
                .padding(.top, 20)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity,alignment: .leading)

            PrimaryButton(text: "Create Account") {
                authStore.dispatch(.didTapOnSignup)
            }
            .padding(.top, 10)

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
        .environmentObject(GlobalStore())
}
