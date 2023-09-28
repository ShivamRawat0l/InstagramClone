//
//  Constant.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 13/09/23.
//

import Foundation

struct Constant {
    static func getImageUrl(title: String) -> String {
        "https://api.dicebear.com/7.x/adventurer/png?seed=\(title)"
    }
}
