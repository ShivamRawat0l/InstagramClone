//
//  SearchService.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 18/10/23.
//

import Foundation
import FirebaseFirestore

struct SearchService {
    
    static func fetchAll() async throws -> [(String, String)] {
        var fetchedNames: [(String, String)] = [];
        let firestoreDB = Firestore.firestore();
        let querySnapshot = try await firestoreDB.collection("users").getDocuments()

        for document in querySnapshot.documents {
            let userDetails = (
                document.documentID,
                document.data()["username"] as? String ?? ""
            )
            fetchedNames.append(userDetails)
        }
        return fetchedNames
    }

    static func filter(searchText: String, names: [(String, String)]) -> [(String, String)] {
        let filteredNames =  names.filter { name in
            let searchContainsEmail =  name.0.lowercased().contains(searchText.lowercased());
            let searchContainsUsername =  name.1.lowercased().contains(searchText.lowercased());
            return searchContainsEmail || searchContainsUsername;
        }
        return filteredNames
    }
}
