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
    
    // Search bar filter
    private var filteredOrders: [Order] {
        if searchText.isEmpty {
            return orders
        } else {
            return orders.filter { $0.orderNumber.lowercased().contains(searchText.lowercased()) || $0.customerName.lowercased().contains(searchText.lowercased())}
        }
    }
    
//    Main body
    var body: some View {
    
        NavigationView{
            VStack{
                // Search bar
                SearchBar(text: $searchText)
                
                //List orders
                NavigationView{
//                    List(filteredOrders) { item in
                    List{
                        ForEach(filteredOrders){ item in
                            NavigationLink(destination: OrderSummaryView(order: item)){
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
                        .onDelete { indexes in
                            for index in indexes{
                                context.delete(orders[index])
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                }
                .navigationViewStyle(.columns)
                
                // Button Create new view
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
    }
}


#Preview {
    ContentView()
//    OrderDetailView()
}
