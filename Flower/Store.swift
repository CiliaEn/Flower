//
//  Store.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import Foundation
import FirebaseFirestoreSwift

struct Store : Identifiable, Codable {
    @DocumentID var id : String?
    
   // let id = UUID()
    
    var name : String
    var deliveryFee : Int
    var deliveryTime : String
    var image : String
}
