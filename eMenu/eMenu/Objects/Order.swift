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
    @Published var orderNumber: String = "None"
    @Published var customerName: String
    @Published var items: [ItemOrder]
    @Published var Addingitems: [ItemOrder]
    @Published var total: Double
    @Published var time: Date
    @Published var dineIn: String
    @Published var isPay: Bool
    @Published var payment: String
    @Published var sendOrder: Bool

    init(customerName: String, items: [ItemOrder], Addingitems: [ItemOrder],  total: Double, time: Date, dineIn: String, isPay: Bool, payment: String, sendOrder: Bool) {
        self.orderNumber = "None"
        self.customerName = customerName
        self.items = items
        self.Addingitems = Addingitems
        self.total = total
        self.time = time
        self.dineIn = dineIn
        self.isPay = isPay
        self.payment = payment
        self.sendOrder = sendOrder
    }
    
    init(order: Order) {
        self.orderNumber = order.orderNumber
        self.customerName = order.customerName
        self.items = order.items.map { ItemOrder(itemOrder: $0) }
        self.Addingitems = order.Addingitems.map { ItemOrder(itemOrder: $0) }
        self.total = order.total
        self.time = order.time
        self.dineIn = order.dineIn
        self.isPay = order.isPay
        self.payment = order.payment
        self.sendOrder = order.sendOrder
    }

    convenience init() {
        self.init(customerName: "", items: [] , Addingitems: [], total: 0, time: Date(), dineIn: "TakeOut", isPay: false, payment: "", sendOrder: false)
    }
}

class OrderStore: ObservableObject {
    @Published var currentOrder: Order = Order()
    @Published var listOrders: [Order] = []
    

    func addOrder(_ order: Order) {
        listOrders.append(order)
    }
}
    


