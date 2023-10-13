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

    func dispatch(_ action: HomeAction) async {
        self.state = await self.reduce(state, action)
        print(self.state, " STATE ")

    }

    func reduce(_ state: HomeState, _ action: HomeAction) async -> HomeState {
        var mutableState = state

        switch action {
        case .fetchPosts:
            mutableState.posts = await homeservice.getPosts()
        case .setPosts(let post):
            mutableState.posts = post
        }
        return mutableState
    }
}
