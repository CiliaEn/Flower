//
//  User.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-27.
//

import Foundation

class User : Codable, ObservableObject {
    
    var name : String
    var phoneNumber : String
    var email : String
    var orders = [Order]()
    var orderIsStarted = false
    
    init(name: String, phoneNumber: String, email: String, orders: [Order] = []) {
            self.name = name
            self.phoneNumber = phoneNumber
            self.email = email
            self.orders = orders
        }
    
}
