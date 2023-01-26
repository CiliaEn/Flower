//
//  Store.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import Foundation
import FirebaseFirestoreSwift

struct Store : Identifiable, Codable, Hashable {
    
    
    
    
    @DocumentID var id : String?
    
    var name : String
    var deliveryFee : Int
    var deliveryTime : String
    var image : String
    var bouquets : [Bouquet]
    
    static func == (lhs: Store, rhs: Store) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
   
    
}
