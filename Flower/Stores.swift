//
//  Stores.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import Foundation

class Stores : ObservableObject {
    
    @Published var list = [Store]()
    
//    init() {
//        addMockData()
//    }
//    
//    func addMockData() {
//       // list.append(Store(name: "Violas blommor", deliveryFee: 89, deliveryTime: "1-2 dagar", image: "flower1"))
//        list.append(Store(name: "Blomsterbutiken", deliveryFee: 69, deliveryTime: "4 timmar", image: "flower2"))
//        list.append(Store(name: "Norrmalmstorgs blommor", deliveryFee: 99, deliveryTime: "6 timmar", image: "flower3"))
//    }
}
