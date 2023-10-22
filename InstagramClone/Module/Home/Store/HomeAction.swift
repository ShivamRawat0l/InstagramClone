//
//  HomeAction.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/10/23.
//

import Foundation

enum HomeAction {
    case fetchPosts
    case likePost(String, String)
    case dislikePost(String, String)
    // Setter actions
    case setPosts([PostType])
    case setPostStatus(AsyncStatus)

}
