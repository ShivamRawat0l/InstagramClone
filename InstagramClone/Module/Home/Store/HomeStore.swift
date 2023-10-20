//
//  HomeStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/10/23.
//

import Foundation

@MainActor
class HomeStore: ObservableObject {
    @Published var state: HomeState

    var homeservice: HomeService

    init(state: HomeState = HomeState(), homeservice: HomeService = HomeService()) {
        self.state = state
        self.homeservice = homeservice
    }

    func dispatch(_ action: HomeAction) {
        self.state = self.reduce(state, action)
    }

    func reduce(_ state: HomeState, _ action: HomeAction) -> HomeState {
        var mutableState = state

        switch action {
        case .fetchPosts:
            Task {
                do {
                    let posts = try await homeservice.getPosts()
                    self.dispatch(.setPosts(posts))
                } catch {
                    print("Error occured @HomeStore.fetchPosts", error.localizedDescription)
                }
            }
        case .likePost(let postID, let email):
            Task {
                do {
                    let selectedPostIndex = self.state.posts.firstIndex {
                        $0.postID == postID
                    }
                    mutableState.posts[selectedPostIndex!] = try await homeservice.likePost(postID: postID, email: email, post: mutableState.posts[selectedPostIndex!])
                    self.dispatch(.setPosts(mutableState.posts))
                } catch {
                    print("Error occured @HomeStore.fetchPosts", error.localizedDescription)
                }
            }
        case .dislikePost(let postID, let email):
            Task {
                do {
                    let selectedPostIndex = self.state.posts.firstIndex {
                        $0.postID == postID
                    }
                    mutableState.posts[selectedPostIndex!] = try await homeservice.dislikePost(postID: postID, email: email, post: mutableState.posts[selectedPostIndex!])
                    self.dispatch(.setPosts(mutableState.posts))
                } catch {
                    print("Error occured @HomeStore.fetchPosts", error.localizedDescription)
                }
            }
        case .setPosts(let post):
            mutableState.posts = post
        }
        return mutableState
    }
}
