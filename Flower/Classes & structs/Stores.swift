//
//  Stores.swift
//  Flower
//
//  Created by Cilia Ence on 2023-01-25.
//

import Foundation

class Stores : ObservableObject, Identifiable {
    
    @Published var list = [Store]()
}
