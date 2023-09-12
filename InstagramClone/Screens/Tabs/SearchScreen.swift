//
//  Searchscreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 10/09/23.
//

import SwiftUI

struct SearchScreen: View {
    @State var search = "";
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading , 10)
                TextField("Search" ,text: $search)
                    .foregroundColor(.gray)
                    .padding()
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("lightgray"))
            }
            .padding()
            Spacer()
        }
        .onAppear {
            
        }
    
    }
}

#Preview {
    SearchScreen()
}
