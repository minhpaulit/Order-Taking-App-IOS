//
//  OrderSummaryView.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import SwiftUI


private let item1 = ItemOrder(name: "Coke", price: 2.99)
private let item2 = ItemOrder(name: "Cookie", price: 1.5)
private let item3 = ItemOrder(name: "Small sauge", price: 1.0)
private let item4 = ItemOrder(name: "Large sauge", price: 2.0)

private let listAddItem = [item1, item2, item3, item4]

struct ListOrderDetailView: View {
    let order: Order
    @State private var listAddedItem: [ItemOrder] = []


    var body: some View {
        VStack {
            // Title: name
            Text("Order Number: \(order.orderNumber)")
                .font(.title)
            
            // Subtitle: time
            HStack{
                Text(order.dineIn)
                    .font(.headline)
                    .padding(.horizontal)
                Text("At: " + DateFormatter.localizedString(from: order.time, dateStyle: .none, timeStyle: .short))
                    .font(.headline)
                    .padding(.horizontal)
            }
            
            Divider()
            
            // List items
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
                
                // List Add items
                if !listAddedItem.isEmpty{
                    List {
                        ForEach(listAddedItem.indices, id: \.self) { index in
                            VStack(alignment: .leading) {
                                HStack{
                                    Text("\(listAddedItem[index].quantity) x \(listAddedItem[index].name)")
                                    Text(String(format: "$%.2f", listAddedItem[index].price))
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    Button(action: {
                                        listAddedItem.remove(at: index)
                                    }) {
                                        Image(systemName: "xmark")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                    
                    
                Text("Total: \(String(format: "%.2f", order.total))")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text("After Tax: \(String(format: "%.2f", order.total))")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
            }
            
            Divider().padding(.top)
            
            HStack{
                Text("Add:")
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.flexible())]) {
                        ForEach(listAddItem, id: \.self) { item in
                            Button(action: {
                                if let existingIndex = listAddedItem.firstIndex(where: { $0.name == item.name }) {
                                    listAddedItem[existingIndex].quantity += 1
                                } else {
                                    listAddedItem.append(item)
                                }
                            }) {
                                Text(item.name)
                                    .padding(.horizontal)
                                    .foregroundColor(.blue) // Text color
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.blue, lineWidth: 2) // Border color and width
                                    )
                            }.padding(.horizontal)
                        }
                    }
                }
            }
            
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

