//
//  SearchStore.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 11/09/23.
//

import Foundation
import FirebaseFirestore

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

enum SearchAction {
    case fetchAll
    case filter(String)
    case setSearchStatus(SearchStatus)
    case setName([(String,String)])
}

class SearchService {
    static func fetchAll(_ dispatch: @escaping (_ action: SearchAction) -> Void) {
        var fetchedNames : [(String,String)] = [];
        let firestoreDB = Firestore.firestore();
        firestoreDB.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                dispatch(.setSearchStatus(.failure))
            } else {
                for document in querySnapshot!.documents {
                    let userDetails = (document.documentID,document.data()["username"] as? String ?? "")
                    fetchedNames.append(userDetails)
                }
                dispatch(.setSearchStatus(.success))
                dispatch(.setName(fetchedNames))
            }
        }
    }
    
    static func filter(searchText: String, 
                       names: [(String,String)] ,
                       _ dispatch: @escaping (_ action: SearchAction) -> Void ) -> [(String,String)] {
        let filteredNames =  names.filter { name in
            return name.0.contains(searchText) || name.1.contains(searchText)
        }
        return filteredNames
    }
}

class SearchStore : ObservableObject {
    @Published var state : SearchState
    
    init(state: SearchState = SearchState()){
        self.state = state;
    }
    
    func dispatch(_ action : SearchAction) {
        self.state =  self.reducer(self.state , action)
    }
    
    func reducer(_ state: SearchState ,
                 _ action: SearchAction) -> SearchState {
        var mutableState = state;
        switch action {
        case .fetchAll:
            mutableState.searchStatus = .pending
            SearchService.fetchAll(self.dispatch)
        case .filter(let searchText):
            if self.state.searchStatus == .success {
                mutableState.filteredNames = SearchService.filter(searchText: searchText,
                                                                  names: self.state.names,
                                                                  self.dispatch)
            }
        case .setSearchStatus(let searchStatus):
            mutableState.searchStatus = searchStatus
        case .setName(let fetchedNames):
            mutableState.names = fetchedNames
        }
        return mutableState;
        
    }
}
