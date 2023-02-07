//
//  Order.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-27.
//

import Foundation

class Order : Codable, Identifiable {
    
    let id = UUID()
    var bouquets : [Bouquet]
    var date : String
    
    init(bouquets: [Bouquet] = [], date: String = "") {
        self.bouquets = bouquets
        self.date = date
    }
        
    func addBouquet(_ bouq : Bouquet) {
        bouquets.append(bouq)
    }
    
}
