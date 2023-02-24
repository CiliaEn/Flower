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
            Text("Shopping Cart")
                .font(.title)
            
            if let user = userManager.user {
                if let order = user.activeOrder {
                    
                    List {
                        ForEach(order.bouquets) { bouquet in
                            HStack {
                                Text("x 1")
                                
                                Text(bouquet.name)
                                Spacer()
                                Text("\(bouquet.price)kr")
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
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.86, green: 0.64, blue: 1.13))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                }
                else{
                    Text("Your cart is empty!")
                }
                
            }
        }
    }
}
