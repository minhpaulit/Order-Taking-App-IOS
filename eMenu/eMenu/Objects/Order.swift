//
//  Order.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import Foundation

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

class Order: Identifiable, ObservableObject {
    let id = UUID()
    var orderNumber: String = "None"
    let customerName: String
    var items: [ItemOrder]
    var Addingitems: [ItemOrder]
    var total: Double
    var time: Date
    var dineIn: String
    var pay: Bool
    var sendOrder: Bool

    init(customerName: String, items: [ItemOrder], Addingitems: [ItemOrder],  total: Double, time: Date, dineIn: String, pay: Bool, sendOrder: Bool) {
        self.orderNumber = generateOrderNumber()
        self.customerName = customerName
        self.items = items
        self.Addingitems = Addingitems
        self.total = total
        self.time = time
        self.dineIn = dineIn
        self.pay = pay
        self.sendOrder = sendOrder
    }

    convenience init() {
        self.init(customerName: "", items: [] , Addingitems: [], total: 0, time: Date(), dineIn: "TakeOut", pay: false, sendOrder: false)
    }
}

class OrderStore: ObservableObject {
    @Published var listOrders: [Order] = []
    @Published var currentOrder: Order?
    

    func addOrder(_ order: Order) {
        listOrders.append(order)
    }
}
    


