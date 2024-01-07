//
//  OrderSummaryView.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import SwiftUI

struct OrderSummaryView: View {
    let order: Order

    var body: some View {
        VStack {
            Text("Order Number: \(order.orderNumber)")
                .font(.title)
            
            HStack{
                Text(order.dineIn)
                    .font(.headline)
                    .padding(.horizontal)
                Text("At: " + DateFormatter.localizedString(from: order.time, dateStyle: .none, timeStyle: .short))
                    .font(.headline)
                    .padding(.horizontal)
            }
            
            Divider()

            Text("Items:")
                .font(.title3)
                .padding(.top)
            if !order.items.isEmpty{
                List(order.items) { item in
                    VStack(alignment: .leading) {
                        HStack{
                            Text("\(item.quantity) x \(item.name)")
                            Text(String(format: "$%.2f", item.price))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        HStack{
                            VStack(alignment: .leading){
                                if !item.noteAdd.isEmpty{
                                    Text("Add:" + item.noteAdd).foregroundColor(.red)
                                }
                                if !item.noteRemove.isEmpty{
                                    Text("Remove" + item.noteRemove).foregroundColor(.red)
                                }
                            }
                            if !item.noteRemove.isEmpty{
                                Text("+" + String(item.additionalFee))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        
                    }
                }
                .listStyle(PlainListStyle())
                Text("Total: \(String(format: "%.2f", order.total))")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text("After Tax: \(String(format: "%.2f", order.total))")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
            }
            
            Divider().padding()
            Spacer()
            HStack{
                Button(action: {
                                // Action to perform when the button is tapped
                                print("Button tapped!")
                            }) {
                                Text("Print")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                Button(action: {
                                // Action to perform when the button is tapped
                                print("Button tapped!")
                            }) {
                                Text("Edit")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                Button(action: {
                                // Action to perform when the button is tapped
                                print("Button tapped!")
                            }) {
                                Text("Paid")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
            }
        }
        .padding()
    }
}


//let item1 = ItemOrder(name: "Nui xao Bo", price: 3.0)
//let item2 = ItemOrder(name: "Suon xao chua ngot", price: 4.0)
//let reviewOrder = Order(orderNumber: "001", customerName: "Mike", items: [item1, item2], total: 7.0, time: Date.now, dineIn: "1", printBill: true, sendOrder: true)

//#Preview {
//    OrderSummaryView(order: reviewOrder)
//}

