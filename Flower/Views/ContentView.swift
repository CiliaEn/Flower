//
//  ContentView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import GoogleMaps

//first comment

struct ContentView: View {
    
    @State private var searchText = ""
    
    @ObservedObject var userManager = UserManager()
    @ObservedObject var firestoreManager = FirestoreManager()
    
    var searchResults: [Store] {
        if searchText.isEmpty {
            return firestoreManager.stores.list
        } else {
            return firestoreManager.stores.list.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        TabView{
            
            //Home page
            NavigationStack{
                List {
                    ForEach(searchResults, id: \.self) { store in
                        
                        NavigationLink(destination: StoreView(store: store, userManager: userManager)){
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
                firestoreManager.listenToFirestore()
                userManager.getUser()
            }
            
            //Search page
            NavigationStack {
                if (searchText != ""){
                    List {
                        ForEach(searchResults, id: \.self) { store in
                            NavigationLink(destination: StoreView(store: store, userManager: userManager)){
                                RowView(store: store)
                            }
                        }
                    }
                } else {
                    SearchView(userManager: userManager)
                }
            }
            .searchable(text: $searchText)
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .onAppear(){
                firestoreManager.listenToFirestore()
            }
            
            //shopping cart page
            NavigationStack{
                ShoppingCartView(userManager: userManager)
            }
            .tabItem {
                Image(systemName: "bag.fill")
                Text("Cart")
            }
            .onAppear(){
                userManager.getUser()
                
            }
            
            //Account page
            NavigationStack{
                if userManager.user != nil {
                    AccountView(userManager: userManager)
                } else {
                    SignInView(userManager: userManager)
                }
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Account")
            }
            .onAppear(){
                userManager.getUser()
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
            
            Text(store.name)
            Text("\(store.deliveryFee)kr - " + store.deliveryTime)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




