//
//  ContentView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import SwiftUI
//import FirebaseFirestore

//first comment

struct ContentView: View {
    
    @StateObject var stores = Stores()
    var body: some View {
        List ($stores.list) { $store in
            
            RowView(store: store)
            
        }
        .onAppear(){
          //  saveToFirestore("Violas blommor", 89, "1-2 dagar", "flower1")
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//func saveToFirestore (_ storeName : String, _ fee: Int, _ time : String, _ img: String) {
//    let db = Firestore.firestore()
//    let store = Store(name: storeName, deliveryFee: fee, deliveryTime: time, image: img)
//
//    do {
//        _ = try db.collection("stores").addDocument(from: store)
//    }
//    catch {
//        print("Could not save to firestore")
//    }
//
//}

struct RowView: View {
    let store: Store
    
    var body: some View {
        VStack{
            Image(store.image)
                .resizable()
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
