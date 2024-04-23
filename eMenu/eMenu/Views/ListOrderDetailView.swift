//
//  OrderSummaryView.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import SwiftUI

var item1 = ItemOrder(name: "Coke", price: 2.99)
var item2 = ItemOrder(name: "Cookie", price: 1.5)
var item3 = ItemOrder(name: "Small sauge", price: 1.0)
var item4 = ItemOrder(name: "Large sauge", price: 2.0)
let listAddItem = [item1, item2, item3, item4]


struct ListOrderDetailView: View {
    @Binding var order: Order
    @State private var paymentMethod: String?
    @State private var AddedItems: [ItemOrder] = []
    @State private var pay: Bool?
    
    var body: some View {
        VStack {
            // Title: name
            Text("Order Number: \(order.orderNumber)")
                .font(.title)
            // Subtitle: table & time
            HStack{
                Text(order.dineIn)
                    .font(.headline)
                    .padding(.horizontal)
                Text("At: " + DateFormatter.localizedString(from: order.time, dateStyle: .none, timeStyle: .short))
                    .font(.headline)
                    .padding(.horizontal)
            }
                        
            // List items
            if !order.items.isEmpty{
                List {
                    ForEach(order.items) { item in
                        VStack(alignment: .leading) {
                            HStack{
                                Text("\(item.quantity) x \(item.name)")
                                Text(String(format: "$%.2f", item.price * Double(item.quantity)))
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
                    // List Added items
                    if !AddedItems.isEmpty{
                        ForEach(AddedItems.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                HStack{
                                    Text("\(AddedItems[index].quantity) x \(AddedItems[index].name)")
                                    Text(String(format: "$%.2f", AddedItems[index].price * Double(AddedItems[index].quantity)))
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    Button(action: {
                                        AddedItems.remove(at: index)
                                    }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .listStyle(PlainListStyle())
            }
            
            // Price total Section
            VStack(alignment:.trailing){
                let subtotal = calculateTotalPrice(items: order.items) + calculateTotalPrice(items: order.Addingitems)
                let total = subtotal*1.15
                Text("Sub Total: \(String(format: "%.2f", subtotal))")
                Text("HST(15%): \(String(format: "%.2f", subtotal*0.15))")
                if paymentMethod == "Card"{
                    Text("Service Charge(3%): \(String(format: "%.2f", subtotal*0.03))")
                }
                Text("Total: \(String(format: "%.2f", paymentMethod == "Card" ? total*1.03:total))").bold()
            }.frame(maxWidth: .infinity, alignment: .trailing)
            
            
            // Buttons Section
            HStack(alignment:.bottom){
                // functions buttons
                VStack(spacing:0){
                    VStack(alignment:.leading, spacing: 1){
                        Text("Quick add:").fixedSize(horizontal: false, vertical: true)
                        HStack{
                            ScrollView(.horizontal) {
                                LazyHGrid(rows: [GridItem(.flexible())]) {
                                    ForEach(listAddItem) { item in
                                        Button(action: {
                                            if let existingIndex = AddedItems.firstIndex(where: { $0.name == item.name }) {
                                                AddedItems[existingIndex].quantity += 1
                                            } else {
                                                AddedItems.append(ItemOrder(itemOrder: item))
                                            }
                                        }) {
                                            Text(item.name)
                                                .font(.title2)
                                                .padding(.horizontal)
                                                .foregroundColor(.blue)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 0)
                                                        .stroke(Color.blue, lineWidth: 2)
                                                )
                                        }
                                    }
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom)
                            }
                        }
                    }
                    
                    HStack{
                        NavigationLink(destination: NewOrderView()) {
                            Text("Edit")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                            
                        }
                        Button(action: {
                        }) {
                            Text("Split Bill")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                            
                        }
                        Button(action: {
                        }) {
                            Text("Discount")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                            
                        }
                    }
                    
                }
                
                // Pay combo buttons
                VStack(spacing:0){
                    HStack(spacing:0){
                        Button(action: {
                            paymentMethod = "Cash"
                        }) {
                            Text("Cash")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(paymentMethod == "Cash" ? order.pay == true ? Color.gray : Color.blue : Color.clear)
                                .foregroundColor(paymentMethod == "Cash" ? Color.white : Color.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(Color.blue, lineWidth: 1))
                        }
                        .disabled(order.pay == true)
                        
                        Button(action: {
                            paymentMethod = "Card"
                        }) {
                            Text("Card")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(paymentMethod == "Card" ? order.pay == true ? Color.gray : Color.blue : Color.clear)
                                .foregroundColor(paymentMethod == "Card" ? Color.white : Color.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(Color.blue, lineWidth: 1))
                        }
                        .disabled(order.pay == true)
                    }
                    Button(action: {
                        order.pay = true
                    }) {
                        Text(order.pay == true ? "Print Bill":"Pay")
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(paymentMethod == nil ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .disabled((paymentMethod == nil))
                    }
                }
                .frame(width:200)
            }
            
        }
        .padding()
    }
}


struct PreviewWrapper: View {
    @State private var ordertemp = Order(customerName: "Alice", items: [item21, item22], Addingitems: [], total: 10.5, time: Date(), dineIn: "TakeOut", pay: false, sendOrder: false)

    var body: some View {
        ListOrderDetailView(order: $ordertemp)
    }
}

#Preview {
//    ListOrderDetailView()
    PreviewWrapper()
}

