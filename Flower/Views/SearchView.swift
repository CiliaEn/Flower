//
//  SearchView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-02-17.
//

import SwiftUI

struct SearchView: View {
    
    let userManager : UserManager
    
    var body: some View {
        VStack{
            HStack{
                FastSearchView(colour: "offers", img: "percent", text: "Kampanjer")
                FastSearchView(colour: "near", img: "mappin.and.ellipse", text: "Nära mig")
            }
            HStack{
                FastSearchView(colour: "fast", img: "box.truck.badge.clock", text: "Snabb leverans")
               
                FastSearchView(colour: "best", img: "medal", text: "Bäst omdömen")
            }
            Text("Mina beställningar")
                .font(.system (size: 20))
            List{
                if let user = userManager.user {
                    ForEach(user.orders) { order in
                        Text(order.storeName)
                       
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
                    .font(.system (size: 20))
                
            }
        }
    }
}
