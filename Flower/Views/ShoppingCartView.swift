//
//  ShoppingCartView.swift
//  Flower
//
//  Created by Cilia Ence on 2023-02-17.
//

import Foundation
import SwiftUI

struct ShoppingCartView: View {

    @ObservedObject var userManager : UserManager
    
    var body: some View {
        VStack{
            
            if let user = userManager.user {
                if let order = user.activeOrder {
                    
                    List {
                        ForEach(order.bouquets) { bouquet in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(bouquet.name)
                                    Text("\(bouquet.price)kr")
                                }
                                Spacer()
                            }
                        }
                    }
                    Button(action: {
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        let dateString = dateFormatter.string(from: date)
                        order.date = dateString
                        user.orders.append(order)
                        user.activeOrder = nil
                        userManager.saveUserToFirestore()
                    }) {
                        Text("Buy")
                    }
                }
                else{
                    Text("Your cart is empty!")
                }
                
            }
        }
    }
}
