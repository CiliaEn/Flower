//
//  Store.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import Foundation
//import FirebaseFirestoreSwift

struct Store : Identifiable {
   // @DocumentID var id : String?
    
    var id = UUID()
    
    var name : String
    var deliveryFee : Int
    var deliveryTime : String
    var image : String
}
