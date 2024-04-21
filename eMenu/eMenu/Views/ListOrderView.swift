//
//  ContentView.swift
//  eMenu
//
//  Created by Minh Paul on 01/01/2024.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var orders: [Order]
    @State private var searchText = ""
    @State private var selection = 0
    
    // Main body
    var body: some View {
    
        TabView(selection: $selection) {
            VStack{
                // Search bar
                SearchBar(text: $searchText)
                
                //List orders
                NavigationView{
                    List{
                        ForEach(filteredOrders){ item in
                            NavigationLink(destination: ListOrderDetailView(order: item)){
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
                        }
                        .onDelete { indexes in
                            for index in indexes{
                                context.delete(orders[index])
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .navigationTitle("Orders" + "(\(orders.count))")
                }
                .navigationViewStyle(.columns)
            }
            .tabItem {
                Image(systemName: "1.square.fill")
                Text("List order")
            }
            
            // Tab 2
            NewOrderView()
            .tabItem {
                Image(systemName: "2.square.fill")
                Text("New Order")
            }
            
            
            Text("Tab 3 Content")
            .tabItem {
                Image(systemName: "3.square.fill")
                Text("Statistic")
            }
        }
    }
       
    
    // Search bar filter
    private var filteredOrders: [Order] {
        if searchText.isEmpty {
            return orders
        } else {
            return orders.filter { $0.orderNumber.lowercased().contains(searchText.lowercased()) || $0.customerName.lowercased().contains(searchText.lowercased())}
        }
    }
}


#Preview {
    ContentView()
//    OrderDetailView()
}
