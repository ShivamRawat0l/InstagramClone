//
//  HomeService.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/10/23.
//

import Foundation

struct HomeService {
    func getPosts() async throws -> [PostType] {
        return try await FirebaseManager.getPosts()
    }
}
