//
//  SearchAction.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 18/10/23.
//

import Foundation

enum SearchAction {
    case fetchAll
    case filter(String)

    // MARK: Setter actions
    case setSearchStatus(SearchStatus)
    case setName([(String,String)])
}
