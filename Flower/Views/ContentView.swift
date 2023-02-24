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
            return firestoreManager.stores
        } else {
            return firestoreManager.stores.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        
        TabView{
            
            //Home page
            NavigationView {
                List {
                    ForEach(searchResults, id: \.self) { store in
                        NavigationLink(
                            destination: StoreView(store: store, userManager: userManager),
                            label: {
                                RowView(store: store)
                            }
                        )
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
                    SearchView(userManager: userManager, firestoreManager: firestoreManager)
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
        VStack {
            Image(store.image)
                .resizable()
                .frame(width: 350, height: 140)
                .padding(.leading, 20)
            
            VStack(alignment: .leading, spacing: 1) {
                HStack(spacing: 6) {
                    Text(store.name)
                        .font(.custom("Avenir-bold", size: 18))
                        .foregroundColor(.black)
                        .padding(.leading, 30)
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.86, green: 0.64, blue: 1.13))
                            .frame(width: 27, height: 27)
                        Text(store.score)
                            .font(.custom("Avenir", size: 12))
                            .foregroundColor(Color(red: 0.36, green: 0.14, blue: 0.63))
                    }
                    .padding(.trailing, 14)
                }
                Text("\(store.deliveryFee)kr - " + store.deliveryTime)
                    .font(.custom("Avenir-bold", size: 14))
                    .foregroundColor(.gray)
                    .padding(.leading, 32)
            }
            .padding(.bottom, 8)
        }
        .frame(width: 396, height: 240)
        .background(Color.white)
        
        .shadow(radius: 4)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




