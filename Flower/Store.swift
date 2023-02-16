//
//  Store.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation

struct Store : Identifiable, Codable, Hashable {
   
    @DocumentID var id : String?
    
    var name : String
    var deliveryFee : Int
    var deliveryTime : String
    var image : String
    var bouquets : [Bouquet]
    var latitude : Double
    var longitude : Double
    
    var coordinate : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func == (lhs: Store, rhs: Store) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
   
}
