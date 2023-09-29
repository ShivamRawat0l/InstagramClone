//
//  ContentView.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 05/09/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var globalStore: GlobalStore

    var globalProfileStore: GlobalProfileState {
        globalStore.state.profileState
    }
    var body: some View {
        NavigationView {
            if case .success = globalStore.state.loginStatus {
                Tabbar()
                    .onAppear {
                        globalStore.dispatch(.messageAction(.addListeners(globalProfileStore.email)))
                        globalStore.dispatch(.profileAction(.getProfile(globalProfileStore.email)))
                    }
                
            } else {
                LoginView()
            }
        }

    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalStore())
}
