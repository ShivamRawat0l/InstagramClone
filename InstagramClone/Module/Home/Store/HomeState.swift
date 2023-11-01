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
    var mediaName: String
    var mediaURL: URL?
    var uploadTime: Double
    var likes: [String]
    var isMediaVideo: Bool
}

struct HomeState {
    var posts: [PostType] = []
    var fetchPostStatus: AsyncStatus = .inital
}
