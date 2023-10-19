//
//  AuthService.swift
//  InstagramClone
//
//  Created by Shivam Rawat on 29/09/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct AuthService {

    func createUser(username: String, email: String) async throws {
        let firestoreDB = Firestore.firestore();
        try await firestoreDB.collection("users").document(email).setData([
            "name": email,
            "username": username + String(email.hash)
        ])
    }

    func signup(username: String,
                email: String,
                password: String) async throws -> String {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        try await createUser(username: username, email: email)
        return email
    }

    func  login(email: String, password: String) async throws -> String {
       let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
       return email
    }
}
