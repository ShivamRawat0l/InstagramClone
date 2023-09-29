//
//  Date.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 27/09/23.
//

import Foundation

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
