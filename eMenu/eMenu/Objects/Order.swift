//
//  Order.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import Foundation
import SwiftData

private var orderCount: Int = 0

func generateOrderNumber() -> String {
        let currentDate = Date()
        let userDefaults = UserDefaults.standard

        if let lastDate = userDefaults.object(forKey: "LastOrderDate") as? Date,
           Calendar.current.isDateInToday(lastDate) {
            orderCount = userDefaults.integer(forKey: "OrderCount")
        } else {
            orderCount = 0
        }

        orderCount += 1
        userDefaults.set(orderCount, forKey: "OrderCount")
        userDefaults.set(currentDate, forKey: "LastOrderDate")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        let dateString = dateFormatter.string(from: currentDate)

        return "\(String(format: "#%03d", orderCount))-\(dateString)"
    }


@Model
class Order: Identifiable {
    let id = UUID()
    var orderNumber:String = "None"
    let customerName: String
    var items: [ItemOrder]
    var total: Double
    var time: Date
    var dineIn: String
    var printBill: Bool
    var sendOrder: Bool
    
    init(customerName: String, items: [ItemOrder], total: Double, time: Date, dineIn: String, printBill: Bool, sendOrder: Bool) {
        self.customerName = customerName
        self.items = items
        self.total = total
        self.time = time
        self.dineIn = dineIn
        self.printBill = printBill
        self.sendOrder = sendOrder
    }
    
    init(){
        self.customerName = ""
        self.items = []
        self.total = 0
        self.time = Date.now
        self.dineIn = "TakeOut"
        self.printBill = false
        self.sendOrder = false
    }
    

    

}
