//
//  Order.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-27.
//

import Foundation

class Order : Codable {
    
    var bouquets : [Bouquet]
    var isActive = true
    
    init(bouquets: [Bouquet] = []) {
            self.bouquets = bouquets
        }
        
    func addBouquet(_ bouq : Bouquet) {
        bouquets.append(bouq)
    }
    
}
