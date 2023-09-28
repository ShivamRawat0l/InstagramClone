//
//  LoginView.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 05/09/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authStore: AuthStore
    
    var isLoading: Bool {
        return authStore.state.loginAuthStatus == .pending
    }
    
    func inputFields() -> some View {
        VStack {
            TextField("Enter your email address", text: $authStore.state.email)
                .disableAutocorrection(true)
                .defaultInput()
            PasswordField(title: "Enter your password", text: $authStore.state.password)
        }
        .padding(.top, 20)
        .textInputAutocapitalization(.never)
    }
    
    var body: some View {
        VStack{
            InstagramLogo()
                .padding()
            inputFields()
            AuthErrorHandler(authStatus: authStore.state.loginAuthStatus)
                .foregroundColor(.red)
                .padding(.top, 20)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                authStore.dispatch(.login)
            } label : {
                PrimaryButton(text: "Login", loading:isLoading)
                    .padding(.top, 100)
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
        .environmentObject(AuthStore(state: AuthState(loginAuthStatus: .failure("Error Occured"),
                                                      signupAuthStatus: .failure("Error Occured"))))
}
