//
//  StoreView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-02-17.
//

import SwiftUI

struct StoreView: View {
    
    let store: Store
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        VStack {
            Image(store.image)
                .resizable()
                .frame(width: 400, height: 200)
            HStack {
                VStack(alignment: .leading) {
                    HStack{
                        Text(store.name)
                            .font(.custom("Avenir", size: 24))
                        Spacer()
                        NavigationLink(destination: {
                            MapView(store: store)
                        }) {
                            Text("Visa på kartan")
                        }
                    }
                    Text("\(store.deliveryFee)kr - \(store.deliveryTime)")
                        .font(.custom("Avenir", size: 16))
                }
                .padding(.leading, 20)
                Spacer()
                
                

            }
            List(store.bouquets) { bouq in
                BouquetView(userManager: userManager, bouq: bouq, store: store)
            }
        }
        .font(.custom("Avenir", size: 16))
    }
}

struct BouquetView: View {

    @ObservedObject var userManager: UserManager
    @State private var showErrorAlert = false
  
    let bouq: Bouquet
    let store: Store
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(bouq.name)
                    .font(.custom("Avenir-Bold", size: 18))
                Text("\(bouq.price)")
                    .font(.custom("Avenir", size: 16))
            }
            Spacer()
            VStack {
                Image(bouq.image)
                    .resizable()
                    .frame(width: 80, height: 80)
                Button(action: {
                    
                    if let user = userManager.user {
                        if let order = user.activeOrder {
                            order.addBouquet(bouq)
                            print("adding bouq to existing order")
                        } else {
                            //create new order and add bouquet and add order to user
                            let newOrder = Order(storeName: store.name, bouquets: [], date: "")
                            newOrder.addBouquet(bouq)
                            user.activeOrder = newOrder
                            print("creating new order")
                        }
                        userManager.saveUserToFirestore()
                    } else {
                        self.showErrorAlert = true
                    }
                }) {
                    Text("Buy")
                }
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Could not add to cart"), message: Text("You have to log in to buy flowers."), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}
