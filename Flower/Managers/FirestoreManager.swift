//
//  FirestoreManager.swift
//  Flower
//
//  Created by Cilia Ence on 2023-02-17.
//

import Foundation
import FirebaseFirestore

class FirestoreManager : ObservableObject {
    
    @Published var stores = [Store]()
    
    func listenToFirestore() {
        let db = Firestore.firestore()
        
        db.collection("stores").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else{return}
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                self.stores.removeAll()
                for document in snapshot.documents {
                    
                    let result = Result {
                        try document.data(as: Store.self)
                    }
                    switch result {
                    case .success(let store) :
                        self.stores.append(store)
                    case .failure(let error) :
                        print ("Error decoding store: \(error)")
                    }
                }
            }
        }
    }
    
    
    func saveToFirestore (_ storeName : String, _ fee: Int, _ time : String, _ img: String, _ bouquets: [Bouquet], _ latitude : Double, _ longitude : Double) {
        let db = Firestore.firestore()
        let store = Store(name: storeName, deliveryFee: fee, deliveryTime: time, image: img, bouquets: bouquets, latitude: latitude, longitude: longitude)
        
        do {
            _ = try db.collection("stores").addDocument(from: store)
        }
        catch {
            print("Could not save to firestore")
        }
    }
}

