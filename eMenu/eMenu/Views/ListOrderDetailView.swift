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
    //    @EnvironmentObject var orderStore: OrderStore
    @StateObject var order:Order
    
        
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
                    if !order.Addingitems.isEmpty{
                        ForEach(order.Addingitems.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                HStack{
                                    Text("\(order.Addingitems[index].quantity) x \(order.Addingitems[index].name)")
                                    Text(String(format: "$%.2f", order.Addingitems[index].price * Double(order.Addingitems[index].quantity)))
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    Button(action: {
                                        order.Addingitems.remove(at: index)
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
            Spacer()
            
            // Price total Section
            VStack(alignment:.trailing){
                let subtotal = calculateTotalPrice(items: order.items) + calculateTotalPrice(items: order.Addingitems)
                let total = subtotal*1.15
                Text("Sub Total: \(String(format: "%.2f", subtotal))")
                Text("HST(15%): \(String(format: "%.2f", subtotal*0.15))")
                if order.payment == "Card"{
                    Text("Service Charge(3%): \(String(format: "%.2f", subtotal*0.03))")
                }
                Text("Total: \(String(format: "%.2f", order.payment == "Card" ? total*1.03:total))").bold()
            }.frame(maxWidth: .infinity, alignment: .trailing)
            
            
            // Buttons Section
            HStack(alignment:.bottom){
                // functions buttons
                VStack(spacing:0){
                    VStack(alignment:.leading, spacing: 1){
                        Text("Quick add:").fixedSize(horizontal: false, vertical: true)
                        // Quick add buttons
                        HStack{
                            ScrollView(.horizontal) {
                                LazyHGrid(rows: [GridItem(.flexible())]) {
                                    ForEach(listAddItem) { item in
                                        Button(action: {
                                            if let index = order.Addingitems.firstIndex(where: { $0.name == item.name }) {
                                                order.Addingitems[index].quantity += 1
                                                order.objectWillChange.send()
                                            } else {
                                                order.Addingitems.append(ItemOrder(itemOrder: item))
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
                        NavigationLink(destination: NewOrderView(order: order)) {
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
                            order.payment = "Cash"
                        }) {
                            Text("Cash")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(order.payment == "Cash" ? order.isPay == true ? Color.gray : Color.blue : Color.clear)
                                .foregroundColor(order.payment == "Cash" ? Color.white : Color.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(Color.blue, lineWidth: 1))
                        }
                        .disabled(order.isPay == true)
                        
                        Button(action: {
                            order.payment = "Card"
                        }) {
                            Text("Card")
                                .font(.title)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(order.payment == "Card" ? order.isPay == true ? Color.gray : Color.blue : Color.clear)
                                .foregroundColor(order.payment == "Card" ? Color.white : Color.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 0)
                                        .stroke(Color.blue, lineWidth: 1))
                        }
                        .disabled(order.isPay == true)
                    }
                    Button(action: {
                        order.isPay = true
                        order.objectWillChange.send()
                    }) {
                        Text(order.isPay == true ? "Print Bill":"Pay")
                            .font(.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(order.payment == "" ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .disabled((order.payment == ""))
                    }
                }
                .frame(width:200)
            }
            
        }
        .padding()
    }
}


struct PreviewWrapper: View {
    @State private var ordertemp = Order(customerName: "Alice", items: [item21, item22], Addingitems: [], total: 10.5, time: Date(), dineIn: "TakeOut", isPay: false, payment: "Card", sendOrder: false)
    
    var body: some View {
        ListOrderDetailView(order: ordertemp)
//            .environmentObject(OrderStore())
    }
}

#Preview {
    //    ListOrderDetailView()
    PreviewWrapper()
}

