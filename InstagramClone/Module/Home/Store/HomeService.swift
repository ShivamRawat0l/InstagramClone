//
//  HomeService.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 12/10/23.
//

import Foundation

struct HomeService {
    func getPosts() async -> [PostType] {
        var posts: [PostType] = []

        await FirebaseManager.getPosts { documents in
            for document in documents {
                print(document.data())
                let owner = document.data()["owner"] as? PostType.Owner ?? PostType.Owner(email: "", username: "")
                let imagename =  document.data()["imageName"] as? String ?? ""
                let imageURL = await FirebaseManager.getImageDownloadURL(id: imagename)
                let post = PostType(postTitle: document.data()["postTitle"] as? String ?? "",
                                    owner: owner,
                                    imageName: document.data()["imageName"] as? String ?? "",
                                    image: imageURL)
                posts.append(post)
            }
        }
        return posts 
    }
}
