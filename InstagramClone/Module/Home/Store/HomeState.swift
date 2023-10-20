//
//  HomeState.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/10/23.
//

import Foundation

struct PostType {
    var postID: String
    var postTitle: String
    var owner: String
    var imageName: String
    var image: URL?
    var uploadTime: Double
    var likes: [String]
}

struct HomeState {
    var posts: [PostType] = []
}
