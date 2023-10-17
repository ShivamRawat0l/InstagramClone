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

    func postImageToInstagramClone(title: String, image: Data, owner: String) async {
        let id = randomString(length: 10)
        FirebaseManager.uploadImage(id: id, image: image, owner: owner, postTitle: title)
    }
}
