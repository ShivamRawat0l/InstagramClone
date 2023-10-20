//
//  Homescreen.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 06/09/23.
//

import SwiftUI
import AsyncAlgorithms

class HomeVM: ObservableObject {
    @Published var isPostLiked: Bool = false
    var task: Task<(), Never>? = nil
    init(isPostLiked: Bool = false) {
        self.isPostLiked = isPostLiked
        Task {
            await toggle()
        }
    }
    
    func change() {
        self.isPostLiked.toggle()
    }


    func sampleFunc() async  {
        do {
            print("SLEEPING", self.isPostLiked)
            try  await Task.sleep(nanoseconds:  4_000_000_000)
            print("WAKE", self.isPostLiked)
        } catch {
            print("Errror")
        }
    }

    func toggle() async {
        for await _ in $isPostLiked.values.debounce(for: .seconds(2)) {
            if task != nil {
                task?.cancel()
            }
             task = Task {
                await sampleFunc()
            }
        }
    }
}

struct HomeScreen: View {
    @EnvironmentObject var globalStore: GlobalStore

    @StateObject var homeStore = HomeStore()
     @StateObject var homeVM = HomeVM()

    var userEmail: String {
        globalStore.state.profileState.email
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
            ScrollView {
                ForEach(homeStore.state.posts, id: \.imageName) { post in
                    var isPostLikedByMe = post.likes.contains {
                        $0 == userEmail
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            AsyncImage(url: URL(string: Constant.getImageUrl(title: post.owner)))
                                .frame(width:40, height: 40)
                                .clipShape(Circle())
                            Text(post.owner)
                        }
                        AsyncImage(url: post.image) {   phaseImage in
                            switch phaseImage {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity)
                            case .empty:
                                ProgressView()
                            case .failure(_):
                                Text("Error")
                            default:
                                Text("Unknown")
                            }
                        }
                        Text("\(post.likes.count) Likes")
                            .bold()
                            .padding(.vertical,6)
                        HStack {
                            Button {
                                //homeVM.change()
                                if isPostLikedByMe {
                                    homeStore.dispatch(.dislikePost(post.postID, userEmail))
                                } else {
                                    homeStore.dispatch(.likePost(post.postID, userEmail))
                                }
                                //homeStore.dispatch(.like)
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

                            Image(systemName: Icons.share)
                                .font(.title2)

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
                .padding()
                Spacer()
            }
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
}
