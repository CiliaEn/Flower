//
//  Bouquet.swift
//  Flower 
//
//  Created by Cilia Ence on 2023-01-26.
//

import Foundation

class Bouquet : Identifiable, Codable {
    
    var id = UUID()
    
    var name : String
    var price : Int
    var image : String
    
    init(name: String, price: Int, image: String) {
        self.name = name
        self.price = price
        self.image = image
    }
}
