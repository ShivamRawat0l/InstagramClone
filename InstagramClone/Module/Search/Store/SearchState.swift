//
//  SearchState.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 18/10/23.
//

import Foundation

enum SearchStatus {
    case initial
    case pending
    case success
    case failure
}

struct SearchState {
    var filteredNames: [(String,String)] = []
    var names: [(String,String)] = []
    var searchStatus: SearchStatus = .initial
}

