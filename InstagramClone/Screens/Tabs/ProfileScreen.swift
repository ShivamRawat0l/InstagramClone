//
//  ProfileTab.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 08/09/23.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var authStore : AuthStore ;
    
    func renderInfo(_ number : String , _ details : String) -> some View {
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
                    .font(.system(size: 20))
                    .bold()
                Text(authStore.state.email.split(separator: "@")[0])
                    .font(.system(size: 26))
                    .bold()
                Image(systemName: "chevron.down")
                    .font(.system(size: 26))
                    .bold()
                Spacer()
                Image(systemName: "plus.square.on.square")
                    .font(.system(size: 26))
                    .bold()
                Image(systemName: "line.3.horizontal.circle")
                    .font(.system(size: 26))
                    .bold()
            }
            .padding(.bottom, 40)
            HStack {
                AsyncImage(url: URL(string: "https://api.dicebear.com/7.x/adventurer/png?seed=\(authStore.state.email)"))
                    .frame(width:  110,height: 110)
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
                renderInfo("10", "Posts")
                Spacer()
                renderInfo("847", "Followers")
                Spacer()
                renderInfo("910", "Following")
            }
            Text(authStore.state.email)
                .bold()
            Text("status")
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ProfileScreen()
        .environmentObject(AuthStore(state: AuthState(email: "temp@temp.com", password: "temp", loginAuthStatus: .success, signupAuthStatus: .success)))
}
