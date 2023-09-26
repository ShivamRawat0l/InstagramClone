//
//  ContentView.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 05/09/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authStore : AuthStore
    @EnvironmentObject var messageStore : MessageStore ;
    @EnvironmentObject var profileStore : ProfileStore ;
    var body: some View {
        NavigationView {
            if authStore.state.loginAuthStatus == .success || authStore.state.signupAuthStatus == .success {
                Tabbar()
                    .onAppear {
                        messageStore.dispatch(.addListeners(authStore.state.email))
                        profileStore.dispatch(.getProfile(authStore.state.email))
                    }
                   
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthStore())
        .environmentObject(SearchStore())
        .environmentObject(MessageStore())
        .environmentObject(ProfileStore())
}
