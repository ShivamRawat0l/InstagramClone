//
//  ProfileTab.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 08/09/23.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var globalStore: GlobalStore

    var globalProfileStore : GlobalProfileState {
        globalStore.state.profileState
    }

    func renderInfo(_ number: String, _ details: String) -> some View {
        VStack {
            Text(number)
                .bold()
            Text(details)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Image(systemName: "lock")
                    .font(.regular20)
                    .bold()
                Text(globalProfileStore.username)
                    .font(.regular26)
                    .bold()
                    .lineLimit(1)
                Image(systemName: "chevron.down")
                    .font(.regular26)
                    .bold()
                Spacer()
                Image(systemName: "plus.square.on.square")
                    .font(.regular26)
                    .bold()
                Image(systemName: "line.3.horizontal.circle")
                    .font(.regular26)
                    .bold()
            }
            .padding(.bottom, 40)
            HStack {
                AsyncImage(url: URL(string: Constant.getImageUrl(title: globalProfileStore.email)))
                    .frame(width:110, height: 110)
                    .clipShape(Circle())
                    .overlay {
                        Image(systemName: "plus")
                            .bold()
                            .foregroundColor(.white)
                            .padding(4)
                            .background{
                                Circle()
                                    .fill(.blue)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .bottomTrailing)
                    }
                Spacer()
                // TODO: Replace Hard Coded Numbers
                renderInfo("10", "Posts")
                Spacer()
                // TODO: Replace Hard Coded Numbers
                renderInfo("847", "Followers")
                Spacer()
                // TODO: Replace Hard Coded Numbers
                renderInfo("910", "Following")
            }
            Text(globalProfileStore.email)
                .bold()
            Text("status")
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ProfileScreen()
}
