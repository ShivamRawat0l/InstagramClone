//
//  Homescreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 06/09/23.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject var homeStore = HomeStore()

    var body: some View {
        VStack {
            let _ = print("asd",homeStore.state.posts)
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
            ScrollView {
                ForEach(homeStore.state.posts, id: \.imageName) { post in
                    VStack{
                        Text(post.owner.email )
                        Text(post.owner.username)
                        AsyncImage(url: post.image) {   phaseImage in
                            switch phaseImage {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 400)
                            case .empty:
                                ProgressView()
                            case .failure(_):
                                Text("Error")
                            default:
                                Text("Unknown")
                            }
                        }
                        Text(post.postTitle)
                    }
                }

                Spacer()
            }
        }
        .onAppear {
            Task {
             await homeStore.dispatch(.fetchPosts)
            }
        }
    }
}

#Preview {
    HomeScreen()
}
