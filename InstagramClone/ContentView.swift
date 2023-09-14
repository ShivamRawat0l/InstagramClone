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
    var body: some View {
        NavigationView {
            if authStore.state.loginAuthStatus == .success {
                Tabbar()
                   
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
}
