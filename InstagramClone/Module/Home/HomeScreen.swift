//
//  Homescreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 06/09/23.
//

import SwiftUI

struct HomeScreen: View {
    
    var body: some View {
        HStack {
            InstagramLogo()
            Spacer()
            NavigationLink(destination: NotificationScreen()) {
                Image(systemName: Icons.heart)
                    .font(.regular26)
                    .tint(.black)
            }
            NavigationLink(destination: MessageScreen()) {
                Image(systemName: Icons.messageCircleFill)
                    .font(.regular26)
                    .tint(.black)
            }
        }
        .padding()
        Spacer()
    }
}

#Preview {
    HomeScreen()
}
