//
//  HomeState.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/10/23.
//

import Foundation

struct PostType {
    struct Owner {
        var email: String
        var username:String
    }

    var postTitle: String
    var owner: Owner
    var imageName: String
    var image: URL?
}

struct HomeState {
    var posts: [PostType] = []
}
