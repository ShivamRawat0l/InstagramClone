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

    func createUser(username: String, email: String) {
        let firestoreDB = Firestore.firestore();

        firestoreDB.collection("users").document(email).setData([
            "name": email,
            "username": username + String(email.hash)
        ])  { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }

    func signup(username: String,
                email: String,
                password: String,
                _ dispatch: @escaping (_ action: AuthAction) -> Void) {
        Auth
            .auth()
            .createUser(withEmail: email, password: password) { authResult ,error in
                if let _ = authResult {
                    createUser(username: username, email: email)
                    dispatch(.setSignupStatus(.success(email)))
                    dispatch(.setLoginStatus(.success(email)))
                } else if let error {
                    dispatch(.setSignupStatus(.failure(error.localizedDescription)))
                } else {
                    dispatch(.setSignupStatus(.failure("Something went wrong.")))
                }
            }
    }

    func  login(email: String,
                password: String,
                _ dispatch: @escaping (_ action: AuthAction) -> Void) {
        Auth
            .auth()
            .signIn(withEmail: email, password: password) { authResult, error  in
                if authResult != nil {
                    dispatch(.setLoginStatus(.success(email)))
                } else  if let error {
                    dispatch(.setLoginStatus(.failure(error.localizedDescription)))
                } else {
                    dispatch(.setLoginStatus(.failure("Something went wrong.")))
                }

            }

    }
}
