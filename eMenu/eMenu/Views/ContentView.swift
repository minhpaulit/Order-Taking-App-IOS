//
//  ContentView.swift
//  eMenu
//
//  Created by Minh Paul on 01/01/2024.
//

import SwiftUI


private var orders = [
    Order(orderNumber: "001", customerName: "John Doe", items: [
        ItemOrder(name: "Pizza", price: 12.99),
        ItemOrder(name: "Salad", price: 8.99),
    ],
          total: 22,
          time: Date.now,
          dineIn: true,
          printBill: true,
          sendOrder: true)
    ,
    Order(orderNumber: "002", customerName: "Jane Smith", items: [
        ItemOrder(name: "Burger", price: 9.99),
        ItemOrder(name: "Fries", price: 4.99),
    ],
          total: 22,
          time: Date.now,
          dineIn: true,
          printBill: true,
          sendOrder: true)
]


struct ContentView: View {

    @State private var selection = 0
    @State private var searchText = ""


    @State private var isShowingOrderDetails = false
    @State private var selectedOrder: Order?
        
// --- End Variable define
    
//    Draw ssearch bar
    struct SearchBar: View {
        @Binding var text: String
        var body: some View {
            HStack {
                TextField("Search", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                }
            }
        }
    }
//    Search bar filter
    var filteredOrders: [Order] {
        if searchText.isEmpty {
            return orders
        } else {
            return orders.filter { $0.orderNumber.lowercased().contains(searchText.lowercased()) || $0.customerName.lowercased().contains(searchText.lowercased())}
        }
    }

//    Main body
    var body: some View {
        TabView(selection: $selection) {
            NavigationView{
                VStack{
                    SearchBar(text: $searchText)
                    NavigationView{
                        
                        List(filteredOrders) { item in
                            NavigationLink(destination: OrderDetailSimpleView(order: item)){
                                VStack(alignment: .leading) {
                                    Text(item.orderNumber)
                                        .font(.headline)
                                    HStack{
                                        Text(item.dineIn)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            
                                        Text(DateFormatter.localizedString(from: item.time, dateStyle: .none, timeStyle: .short))
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    
                                }
                            }
                            .navigationTitle("Orders" + "(\(orders.count))")
                        }
                        .listStyle(PlainListStyle())
                    }
                    .navigationViewStyle(.columns)
                    NavigationLink(destination: OrderDetailView()) {
                                        Text("New Order")
                                            .padding()
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(8)
                                    }
                }
            }
            .navigationViewStyle(.stack)
            
            .tabItem {
                Image(systemName: "1.square")
                Text("Tab 2")
            }
            .tag(0)
            
            Text("Tab 2 Content")
            .tabItem {
                Image(systemName: "2.square")
                Text("Tab 2")
            }
            .tag(1)
        }
    }
}


//Brieft order
struct OrderDetailSimpleView: View {
    let order: Order

    var body: some View {
        VStack {
            Text("Order Number: \(order.orderNumber)")
                .font(.title)
            
            HStack{
                Text(order.dineIn)
                    .font(.headline)
                    .padding(.horizontal)
                Text(DateFormatter.localizedString(from: order.time, dateStyle: .none, timeStyle: .short))
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




#Preview {
    ContentView()
//    OrderDetailView()
}
