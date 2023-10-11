//
//  LoginView.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 05/09/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var globalStore: GlobalStore

    @StateObject var authStore = AuthStore()

    var isLoading: Bool {
        return authStore.state.loginAuthStatus == .pending
    }

    func inputFields() -> some View {
        VStack {
            TextField("Enter your email address", text: $authStore.state.email)
                .disableAutocorrection(true)
                .textFieldStyle(DefaultInputStyle())
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

            PrimaryButton(text: "Login", loading:isLoading) {
                authStore.dispatch(.didTapOnLogin)
            }
            .padding(.top, 50)

            Spacer()
            NavigationLink {
                SignupView();
            } label : {
                Text("Create Account")
            }
        }
        .padding()
        .onChange(of: authStore.state.loginAuthStatus) {
            switch authStore.state.loginAuthStatus {
            case .success(let email):
                globalStore.dispatch(.authAction(.didTapOnLogin(email,.success)))
            case .initial, .pending, .failure: break
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(GlobalStore())
}
