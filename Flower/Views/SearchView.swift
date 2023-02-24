//
//  SearchView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-02-17.
//

import SwiftUI

struct SearchView: View {
    
    let userManager : UserManager
    let firestoreManager : FirestoreManager
    
    var body: some View {
        VStack{
            HStack{
                FastSearchView(colour: "offers", img: "percent", text: "Kampanjer")
                FastSearchView(colour: "near", img: "mappin.and.ellipse", text: "Nära mig")
            }
            .padding(.bottom, 1)
            HStack{
                FastSearchView(colour: "fast", img: "box.truck.badge.clock", text: "Snabb leverans")
                
                FastSearchView(colour: "best", img: "medal", text: "Bäst omdömen")
            }
            HStack{
                Text("Mina beställningar")
                    .font(.custom("Avenir-bold", size: 20))
                    .padding(.leading, 16)
                Spacer()
            }
            List{
                if let user = userManager.user {
                    ForEach(user.orders) { order in
                        
                        ForEach(firestoreManager.stores) { store in
                            if(store.name == order.storeName){
                                NavigationLink(
                                    destination: StoreView(store: store, userManager: userManager),
                                    label: {
                                        Image(store.image)
                                            .resizable()
                                            .frame(width: 36, height: 36)
                                        Text(store.name)
                                            .font(.custom("Avenir", size: 17))
                                    }
                                )
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct FastSearchView: View {
    
    let colour : String
    let img : String
    let text : String
    
    var body: some View {
        ZStack{
            Image(colour)
                .resizable()
                .frame(width: 180, height: 160)
                .cornerRadius(10)
            VStack{
                Image(systemName: img)
                    .resizable()
                    .frame(width: 50, height: 48)
                Text(text)
                    .font(.custom("Avenir", size: 20))
                
            }
        }
    }
}
