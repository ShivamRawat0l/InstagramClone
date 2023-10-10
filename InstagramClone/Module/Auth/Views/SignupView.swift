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
            TextField(T.SignupScreen.enterUsername, text: $authStore.state.username)
                .textFieldStyle(DefaultInputStyle())
            TextField(T.SignupScreen.enterEmail, text: $authStore.state.email)
                .textFieldStyle(DefaultInputStyle())
            PasswordField(title: T.SignupScreen.enterPassword, text: $authStore.state.password)
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

            PrimaryButton(text: T.SignupScreen.Create_Account) {
                authStore.dispatch(.didTapOnSignup)
            }
            .padding(.top, 100)

            Spacer()
            Button {
                dismiss();
            } label : {
                Text(T.SignupScreen.signIn)
            }
        }
        .navigationTitle(T.SignupScreen.New_Account)
        .navigationBarTitleDisplayMode(.large)
        .padding()
    }
}

#Preview {
    SignupView()
        .environmentObject(GlobalStore())
}
