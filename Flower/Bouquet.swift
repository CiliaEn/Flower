//
//  Bouquet.swift
//  Flower 
//
//  Created by Cilia Ence on 2023-01-26.
//

import Foundation

struct Bouquet : Identifiable, Codable {
    
    var id = UUID()
    
    var name : String
    var price : Int
    var image : String
}
