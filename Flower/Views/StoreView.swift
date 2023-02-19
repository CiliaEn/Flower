//
//  StoreView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-02-17.
//

import SwiftUI

struct StoreView : View {
    
    let store : Store
    @ObservedObject var userManager: UserManager
    
    var body: some View{
        VStack{
            Image(store.image)
                .resizable()
                .frame(width: 400, height: 200)
            HStack {
                Text(store.name)
                Text("\(store.deliveryFee)kr - " + store.deliveryTime)
            }
            NavigationLink(destination: {
                            MapView(store: store)
                        }) {
                            Text("Visa på kartan")
                        }

            List(store.bouquets) { bouq in
                BouquetView(userManager: userManager, bouq: bouq, store: store)
            }
        }
    }
}

struct BouquetView: View {

    @ObservedObject var userManager: UserManager
  
    let bouq : Bouquet
    let store : Store
    
    
    var body: some View {
        HStack{
            VStack{
                Text(bouq.name)
                Text("\(bouq.price)")
            }
            Spacer()
            VStack{
                Image(bouq.image)
                    .resizable()
                    .frame(width: 80, height: 80)
                Button(action: {
                    
                    if let user = userManager.user{
                        
                        if let order = user.activeOrder {
                            order.addBouquet(bouq)
                            print("adding bouq to existing order")
                        }
                            else {
                                //create new order and add bouquet and add order to user
                                let newOrder = Order(storeName: store.name, bouquets: [], date: "")
                                newOrder.addBouquet(bouq)
                                user.activeOrder = newOrder
                                print("creating new order")
                            }
                        userManager.saveUserToFirestore()
                    }
                    
                }) { Text("Buy")}
            }
        }
    }
}
