//
//  SearchStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 11/09/23.
//

import Foundation

@MainActor
class SearchStore: ObservableObject {
    @Published var state: SearchState
    
    init(state: SearchState = SearchState()){
        self.state = state;
    }
    
    func dispatch(_ action: SearchAction) {
        self.state = self.reducer(self.state, action)
    }
    
    func reducer(_ state: SearchState, _ action: SearchAction) -> SearchState {
        var mutableState = state;
        switch action {
        case .fetchAll:
            Task {
                do {
                    self.dispatch(.setSearchStatus(.pending))
                    let fetchedNames = try await SearchService.fetchAll()
                    self.dispatch(.setSearchStatus(.success))
                    self.dispatch(.setName(fetchedNames))
                } catch {
                    self.dispatch(.setSearchStatus(.failure))
                }
            }
        case .filter(let searchText):
            if self.state.searchStatus == .success {
                mutableState.filteredNames = SearchService.filter(searchText: searchText,
                                                                  names: self.state.names)
            }
            // MARK: Setter actions
        case .setSearchStatus(let searchStatus):
            mutableState.searchStatus = searchStatus
        case .setName(let fetchedNames):
            mutableState.names = fetchedNames
        }
        return mutableState;
    }
}
