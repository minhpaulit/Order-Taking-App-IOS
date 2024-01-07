//
//  ItemOrder.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import Foundation
import SwiftData

@Model
class ItemOrder: Identifiable{
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
    
    init(name: String, quantity: Int, price: Double, noteAdd: String, noteRemove: String, additionalFee: Double) {
        self.imageName = ""
        self.name = name
        self.quantity = quantity
        self.price = price
        self.noteAdd = noteAdd
        self.noteRemove = noteRemove
        self.additionalFee = additionalFee
    }
    
    init() {
        self.imageName = "temp"
        self.name = "temp"
        self.quantity = 1
        self.price = 1.0
        self.noteAdd = "temp"
        self.noteRemove = "temp"
        self.additionalFee = 1.0
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
