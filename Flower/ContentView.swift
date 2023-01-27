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
    @State private var searchText = ""
    
    var searchResults: [Store] {
        if searchText.isEmpty {
            return stores.list
        } else {
            return stores.list.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        TabView{
            NavigationStack{
                List {
                    ForEach(searchResults, id: \.self) { store in
                        
                        NavigationLink(destination: StoreView(store: store)){
                            RowView(store: store)
                                
                        }
                    }
                }
                .frame(width: 420)
            }
            
            .searchable(text: $searchText)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .onAppear(){
                listenToFirestore()
            }
            NavigationStack {
                if (searchText != ""){
                    List {
                        ForEach(searchResults, id: \.self) { store in
                            
                            NavigationLink(destination: StoreView(store: store)){
                                RowView(store: store)
                            }
                        }
                    }
                }
                VStack{
                    HStack{
                        Image("offers")
                            .resizable()
                            .frame(width: 180, height: 160)
                        Image("near")
                            .resizable()
                            .frame(width: 180, height: 160)
                    }
                    HStack{
                        Image("fast")
                            .resizable()
                            .frame(width: 180, height: 160)
                        Image("best")
                            .resizable()
                            .frame(width: 180, height: 160)
                    }
                    Text("Mina beställningar")
                    
                }
                
            }
            .searchable(text: $searchText)
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .onAppear(){
                listenToFirestore()
            }
            
            Text("shopping cart")
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Cart")
                }
            
            NavigationStack{
                Text("Namn Efternamn")
                    .font(.system(size: 36))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Text("0701234567")
                    .font(.system(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.gray)
                    .padding()
                VStack{
                    ItemView(img: "list.bullet.clipboard", text: "Beställningar")
                    ItemView(img: "dollarsign.square", text: "Betalning")
                    ItemView(img: "megaphone", text: "Kampanjer")
                    ItemView(img: "questionmark.circle", text: "Hjälp")
                    ItemView(img: "gearshape", text: "Inställningar")
                }
                Spacer()
            }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
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

struct ItemView : View {
    
    let img : String
    let text : String
    
    var body: some View {
        HStack{
            Image(systemName: img)
                .font(.system(size: 20))
            Text(text)
                .font(.system(size: 20))
            Spacer()
        }
        .padding()
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

struct RowView: View {
    let store: Store
    
    var body: some View {
        VStack{
            Image(store.image)
                .resizable()
                .frame(width: 397, height: 160)
            HStack{
               
                Text(store.name)
                  //  .frame(maxWidth: .infinity, alignment: .leading)
                    
                Text("\(store.deliveryFee)kr - " + store.deliveryTime)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                    
            }
           // .padding()
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
