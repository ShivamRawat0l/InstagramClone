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
    var names : [String];
    var searchStatus : SearchStatus;
}

enum SearchAction {
    case search(String)
    case setSearchStatus(SearchStatus)
}

class SearchService {
    static func search(searchText : String,_ dispatch: @escaping (_ action : SearchAction) -> Void ) {
        let firestoreDB = Firestore.firestore();
        firestoreDB.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
}

class SearchStore : ObservableObject {
    var state : SearchState ;
    
    init(state: SearchState = SearchState(names: [], searchStatus: .initial)){
        self.state = state;
    }
    
    func dispatch(_ action : SearchAction) {
        self.state =  self.reducer(self.state , action)
    }
    
    func reducer(_ state : SearchState ,  _ action : SearchAction ) -> SearchState {
        var mutableState = state;
        switch(action) {
        case .search(let searchText) :
            mutableState.searchStatus = .pending
            SearchService.search(searchText: searchText, self.dispatch)
        case .setSearchStatus(let searchStatus ):
            mutableState.searchStatus = searchStatus;
        }
        return mutableState;
    }
}
