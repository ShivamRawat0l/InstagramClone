//
//  Searchscreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI

struct SearchScreen: View {
    @State var search: String = .empty
    @StateObject var searchStore = SearchStore()

    func renderUser(email: String, userName: String) -> some View {
        NavigationLink(destination: MessageDetailScreen(email: email, username: userName)){
            UserTab(title: email, caption: userName)
                .padding()
        }
    }

    var body: some View {
        VStack {
            if searchStore.state.searchStatus == .success {
                ForEach(searchStore.state.filteredNames, id: \.self.0) { names in
                    renderUser(email: names.0, userName: names.1)
                }
            }
            Spacer()
        }
        .searchable(text: $search, placement: .automatic, prompt: "Search")
        .onChange(of: search) {
            searchStore.dispatch(.filter(search))
        }
        .task {
            searchStore.dispatch(.fetchAll)
        }
    }
}

#Preview {
    SearchScreen()
}
