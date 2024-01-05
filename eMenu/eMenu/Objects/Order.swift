//
//  Order.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import Foundation

struct Order: Identifiable {
    let id = UUID()
    let orderNumber: String
    let customerName: String
    var items: [ItemOrder]
    var total: Double
    var time: Date
    var dineIn: String
    var printBill: Bool
    var sendOrder: Bool
    
    init(orderNumber: String, customerName: String, items: [ItemOrder], total: Double, time: Date, dineIn: Bool, printBill: Bool, sendOrder: Bool) {
        self.orderNumber = orderNumber
        self.customerName = customerName
        self.items = items
        self.total = total
        self.time = time
        self.dineIn = "TakeOut"
        self.printBill = printBill
        self.sendOrder = sendOrder
    }
    
    init(){
        self.orderNumber = ""
        self.customerName = ""
        self.items  = []
        self.total = 0
        self.time = Date.now
        self.dineIn = "1"
        self.printBill = false
        self.sendOrder = false
    }
    
    
}
