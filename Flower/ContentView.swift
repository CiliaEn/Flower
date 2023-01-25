//
//  ContentView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import SwiftUI
import FirebaseFirestore

//first comment

struct ContentView: View {
    
    @StateObject var stores = Stores()
    var body: some View {
        TabView{
            List ($stores.list) { $store in
                RowView(store: store)
            }
            
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .onAppear(){
                // saveToFirestore("Blombutiken", 99, "8 timmar", "flower4")
                listenToFirestore()
            }
            Text("search view")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            Text("account view")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
            
        }
    }
    
    func saveToFirestore (_ storeName : String, _ fee: Int, _ time : String, _ img: String) {
        let db = Firestore.firestore()
        let store = Store(name: storeName, deliveryFee: fee, deliveryTime: time, image: img)
        
        do {
            _ = try db.collection("stores").addDocument(from: store)
        }
        catch {
            print("Could not save to firestore")
        }
        
    }
    
    func listenToFirestore() {
        let db = Firestore.firestore()
        
        db.collection("stores").addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else{return}
            
            if let err = err {
                print("Error getting document \(err)")
            } else {
                stores.list.removeAll()
                for document in snapshot.documents {
                    
                    let result = Result {
                        try document.data(as: Store.self)
                    }
                    switch result {
                    case .success(let store) :
                        stores.list.append(store)
                    case .failure(let error) :
                        print ("Error decoding store: \(error)")
                    }
                }
                
                
            }
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct RowView: View {
    let store: Store
    
    var body: some View {
        VStack{
            Image(store.image)
                .resizable()
                .frame(width: 400, height: 160)
            HStack{
                
                Text(store.name)
                HStack{
                    Text("\(store.deliveryFee)kr")
                    Text(store.deliveryTime)
                }
            }
        }
    }
}
