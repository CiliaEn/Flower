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
    @State var showingStoreSheet = false
    @State var storeNumber = 0
    
    
    
    
    var body: some View {
        TabView{
            List ($stores.list) { $store in
                
                NavigationLink(destination: StoreView(store: store)){
                    RowView(store: store)
                }
                
                
            }
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
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
            //        .sheet(isPresented: $showingStoreSheet) {
            //            StoreSheet()
            //        }
        
        .onAppear(){
//            var b1 = Bouquet(name: "Höstbukett", price: 200, image: "fall")
//            var b2 = Bouquet(name: "Vårbukett", price: 200, image: "spring")
//            var b3 = Bouquet(name: "Rosbukett", price: 200, image: "roses")
//            saveToFirestore("Blombutiken", 99, "8 timmar", "flower4", [b1, b2, b3])
            listenToFirestore()
            
        }
    }
                               
                               
                               
    func saveToFirestore (_ storeName : String, _ fee: Int, _ time : String, _ img: String, _ bouquets: [Bouquet]) {
        let db = Firestore.firestore()
        let store = Store(name: storeName, deliveryFee: fee, deliveryTime: time, image: img, bouquets: bouquets )
        
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

struct StoreView : View {
    
    let store : Store
    
    var body: some View{
        VStack{
            Image(store.image)
                .resizable()
                .frame(width: 400, height: 240)
            Text(store.name)
            Text("\(store.deliveryFee)kr - " + store.deliveryTime)
            List(store.bouquets) { bouq in
                BouquetView(bouq: bouq)
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
               
                    Text("\(store.deliveryFee)kr - " + store.deliveryTime)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
            }
        }
    }
}

struct BouquetView: View {
    let bouq : Bouquet
    
    var body: some View {
        HStack{
            VStack{
                Text(bouq.name)
                Text("\(bouq.price)")
            }
            Spacer()
            Image(bouq.image)
                .resizable()
                .frame(width: 80, height: 80)
        }
    }
}
