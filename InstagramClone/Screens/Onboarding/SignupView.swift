//
//  SignupView.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 06/09/23.
//

import Foundation
import SwiftUI

struct SignupView : View {
    @EnvironmentObject var loginStore : AuthStore ;
    var body: some View {
        VStack {
            TextField("Enter your email address", text: $loginStore.state.email)
            TextField("Enter your password", text: $loginStore.state.password)
            Button {
                loginStore.dispatch(.login)
            } label : {
                Text("Create Account")
            }
            NavigationLink {
                SignupView();
            } label : {
                Text("Sign In" )
            }
        }
        .padding()
    }
}

#Preview {
    LoginView()
}
