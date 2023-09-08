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
        VStack {
          InstagramLogo()
            TextField("Enter your email address", text: $authStore.state.email)
            TextField("Enter your password", text: $authStore.state.password)
            
            Button {
                authStore.dispatch(.signup)
            } label : {
                PrimaryButton(text: "Create Account")
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
        .environmentObject(AuthStore())
}
