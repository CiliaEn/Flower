//
//  UserManager.swift
//  Flower
//
//  Created by Cilia Ence on 2023-02-02.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserManager: ObservableObject {
    @Published var user: User?
    
    init(user: User? = nil) {
        self.user = user
    }
    
    func saveUserToFirestore() {
        guard let usern = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(usern.uid)
        userRef.setData(try! Firestore.Encoder().encode(user)) { (error) in
            if let error = error {
                print("Error updating user: \(error)")
            } else {
                print("User successfully updated")
            }
        }
    }
    func getUser() {
        guard let user = Auth.auth().currentUser else { return }
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user.uid)
        
        docRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else { return }
            do {
                self.user = try snapshot.data(as: User.self)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func signOut() {
        try! Auth.auth().signOut()
        self.user = nil
    }
}
