//
//  Homescreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 06/09/23.
//

import SwiftUI
import AsyncAlgorithms
import AVFoundation
import AVKit

struct HomeScreen: View {
    @EnvironmentObject var globalStore: GlobalStore
    @StateObject var homeStore = HomeStore()
    @State var originalImage: Image?
    @State var thumbnailImage: Image?

    var userEmail: String {
        globalStore.state.profileState.email
    }

    func renderPost(post: PostType) -> some View {
        let _ = print(post)
        let isPostLikedByMe = post.likes.contains {
            $0 == userEmail
        }
        return VStack(alignment: .leading) {
            HStack {
                AsyncImage(url: URL(string: Constant.getImageUrl(title: post.owner)))
                    .frame(width:40, height: 40)
                    .clipShape(Circle())
                Text(post.owner)
            }
            if post.isMediaVideo {
                VideoPlayer(player: AVPlayer(url: post.mediaURL!)) {
                    VStack {
                        Spacer()
                        Image(systemName: "play.fill")
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, height: 300)
            } else {
                AsyncImage(url: post.mediaURL) { phaseImage in
                    switch phaseImage {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .task {
                                originalImage = image
                                let uiimage = ImageRenderer(content: image).uiImage
                                let thumbnail =  await withCheckedContinuation { continuation in
                                    uiimage!.prepareThumbnail(of: CGSize(width: 200, height: 200)) { uiImage in
                                        continuation.resume(returning: uiImage)
                                    }
                                }
                                if let thumbnail {
                                    thumbnailImage = Image(uiImage: thumbnail)
                                }
                            }

                    case .empty:
                        ProgressView()
                    case .failure(_):
                        Text("Error")
                    default:
                        Text("Unknown")
                    }
                }
            }
            Text("\(post.likes.count) Likes")
                .bold()
                .padding(.vertical,6)
            HStack {
                Button {
                    if isPostLikedByMe {
                        homeStore.dispatch(.dislikePost(post.postID, userEmail))
                    } else {
                        homeStore.dispatch(.likePost(post.postID, userEmail))
                    }
                } label: {
                    if isPostLikedByMe {
                        Image(systemName: Icons.likeFill)
                            .font(.title2)
                    } else {
                        Image(systemName: Icons.like)
                            .font(.title2)
                    }

                }
                Image(systemName: Icons.comment)
                    .font(.title2)
                if let originalImage, let thumbnailImage {
                    ShareLink(item:  originalImage,
                              subject: Text("Sharing a post"),
                              message: Text("Instagram Clone Application"),
                              preview: SharePreview(post.postTitle,  image: thumbnailImage)
                    ) {
                        Image(systemName: Icons.share)
                            .font(.title2)
                    }
                }
                Spacer()
                Image(systemName: Icons.bookmark)
                    .font(.title2)
            }
            .padding(.bottom,6)
            HStack {
                Text(post.owner)
                    .bold()
                Text(post.postTitle)
            }
        }
    }

    var body: some View {
        VStack {
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
            if homeStore.state.fetchPostStatus == .pending {
                ProgressView()
            } else {
                ScrollView {
                    ForEach(homeStore.state.posts, id: \.mediaName) { post in
                        renderPost(post: post)
                    }
                    .padding()
                }
            }
            Spacer()
        }
        .refreshable {
            homeStore.dispatch(.fetchPosts)
        }
        .task {
            homeStore.dispatch(.fetchPosts)
        }
    }
}

#Preview {
    HomeScreen()
        .environmentObject(GlobalStore(state: GlobalState(profileState:
                                                            GlobalProfileState(email: "A@a.com", 
                                                                               username: "A_a")
                                                         )
        ))
}
