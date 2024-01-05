//
//  ItemOrder.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import Foundation

struct ItemOrder: Identifiable{
    let id = UUID()
    let imageName: String
    var name: String
    let descriptions = "It's very delicious"
    let alergy = false
    var quantity: Int
    var price: Double
    var noteAdd: String
    var noteRemove: String
    var additionalFee: Double
    
    init() {
        self.imageName = ""
        self.name = ""
        self.quantity = 1
        self.price = 0.0
        self.noteAdd = ""
        self.noteRemove = ""
        self.additionalFee = 0.0
    }
    
    init(name: String, price: Double) {
        self.imageName = ""
        self.name = name
        self.quantity = 1
        self.price = price
        self.noteAdd = ""
        self.noteRemove = ""
        self.additionalFee = 0.0
    }
}
