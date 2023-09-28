//
//  Searchscreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI

struct SearchScreen: View {
    @State var search = ""
    
    @EnvironmentObject var searchStore: SearchStore
    
    func renderUser(email: String, userName: String) -> some View {
        NavigationLink(destination: MessageDetailScreen(email: email, username: userName)){
            UserTab(title: email, caption: userName)
                .padding()
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading , 14)
                    .padding(.trailing, 4)
                TextField("Search" ,text: $search)
                    .foregroundColor(.gray)
                    .padding(.vertical)
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("lightgray"))
            }
            .padding()
            if searchStore.state.searchStatus == .success {
                if search == "" {
                    ForEach(searchStore.state.names, id: \.self.0) { names in
                        renderUser(email: names.0, userName: names.1)
                    }
                }
                else {
                    ForEach(searchStore.state.filteredNames, id: \.self.0) { names in
                        renderUser(email: names.0, userName: names.1)
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            searchStore.dispatch(.fetchAll)
        }
        
    }
}

#Preview {
    SearchScreen()
        .environmentObject(SearchStore())
}
