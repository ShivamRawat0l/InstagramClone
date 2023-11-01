//
//  UploadService.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/10/23.
//

import Foundation

struct UploadService {
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }

    func postImageToInstagramClone(title: String, media: Data, owner: String, isMediaVideo: Bool = false, fileExtension: String = "") async throws {
        let id = randomString(length: 10)
        try await FirebaseManager.uploadImage(id: id, media: media, owner: owner, postTitle: title, isMediaVideo: isMediaVideo, fileExtension: fileExtension)
    }
}
