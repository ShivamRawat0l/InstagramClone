//
//  HomeService.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/10/23.
//

import Foundation

struct HomeService {
    func getPosts() async throws -> [PostType] {
        var posts = try await FirebaseManager.getPosts()
        posts.sort { post1, post2 in
            if post1.uploadTime > post2.uploadTime {
                return true
            } else  {
                return false
            }
        }
        return posts
    }

    func likePost(postID: String, email: String, post: PostType) async throws -> PostType {
        var mutablePost = post
        try await FirebaseManager.likePost(postID: postID, myEmailID: email)
        mutablePost.likes.append(email)
        return mutablePost
    }

    func dislikePost(postID: String, email: String, post: PostType) async throws -> PostType {
        var mutablePost = post
        try await FirebaseManager.dislikePost(postID: postID, myEmailID: email)
        mutablePost.likes = mutablePost.likes.filter {
            $0 != email
        }
        return mutablePost
    }


}
