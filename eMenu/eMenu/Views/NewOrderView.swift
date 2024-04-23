//
//  OrderDetailView.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import SwiftUI

//NEW ORDER BIG VIEW
struct NewOrderView: View {
    
    
    @EnvironmentObject var orderStore: OrderStore
    
    private var thisOrder: Order?
    
    @State private var itemOrders: [ItemOrder] = []
    @State private var time = Date()
    @State private var table: String = "TakeOut"
    
    @State private var selectedCategory = categories[0]
    @State private var customerTF = ""
    
    
    var body: some View {
        
        if let order = thisOrder {
                        Text("Order ID: \(order.id)")
                        // Other views related to the order
                    } else {
                        Text("No order selected")
                    }
        
        
        GeometryReader { geometry in
            VStack{
                // SECTION 1
                HStack(spacing: 0) {
                    // LEFT COLUMN: list categories
                    VStack{
                        List{
                            ForEach(categories){ item in
                                Button(action: {
                                    selectedCategory = item
                                }){
                                    Text(item.name)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                    .background(Color(UIColor.systemGray6))
                    .padding(5)
                    .cornerRadius(25)
                    .frame(width: geometry.size.width * 0.2)
                    
                    
                    // MIDDLE COLUMN: list items
                    VStack{
                        List{
                            ForEach(selectedCategory.items){ item in
                                Button(action: {
                                    let newItem = ItemOrder(name: item.name, price: item.price)
                                    itemOrders.append(newItem)
                                }){
                                    HStack{
                                        Text(item.name)
                                        Spacer()
                                        if !item.allergy {
                                            Image(systemName: "leaf")
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                    .background(Color(UIColor.systemGray6))
                    .padding(5)
                    .cornerRadius(25)
                    .frame(width: geometry.size.width * 0.3)
                    
                    
                    // RIGHT COLUMN: summary
                    VStack{
                        Text("Order: #005-240709").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).padding(.top)
                        HStack{
                            // Customer Picker
                            TextField("Customer", text: $customerTF, onCommit: {
                                hideKeyboard()
                            }).textFieldStyle(RoundedBorderTextFieldStyle())
                                .onTapGesture {
                                    hideKeyboard()
                                }
                            Spacer()
                            
                            // Table Picker
                            Picker("Select the table", selection: $table) {
                                ForEach(tables, id: \.self) { option in Text(option) } }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 60)
                            Spacer()
                            
                            // Time Picker
                            VStack{
                                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(DefaultDatePickerStyle())
                                    .labelsHidden()
                                    .disabled(table != "TakeOut")
                                    .background(time < Date.now && table == "TakeOut" ? Color.red.opacity(0.5) : Color.clear)
                                    .cornerRadius(10)
                            }
                        }.padding(.horizontal)
                        Divider()
                        Spacer()
                        if !itemOrders.isEmpty {
//                            if thisOrder?.items != nil {
//                                ListItemsView(items: thisOrder?.items)
//                            }
                            ListItemsView(items: $itemOrders)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }
                    }
                    .background(Color(UIColor.systemGray6))
                    .padding(5)
                    .frame(width: geometry.size.width * 0.5)
                    
                }
                .background(Color(UIColor.systemGray5))
                .frame(height: geometry.size.height * 0.8)
                
                
                
                // SECTION 2
                HStack(spacing: 0) {
                    // Column 1
                    VStack{
                        Text("__________________________________________________________________")
                        Spacer()
                        
                    }
                    .background(Color(UIColor.systemGray6))
                    .padding(5)
                    .cornerRadius(25)
                    
                    
                    // Column 2
                    VStack{
                        SummaryPriceView(items: itemOrders).padding()
                        Divider()
                        Spacer()
                        SummaryButtonView(items: $itemOrders, time: $time, table: $table)
                    }
                    .background(Color(UIColor.systemGray6))
                    .padding(5)
                    .cornerRadius(25)
                    
                    
                }
                .background(Color(UIColor.systemGray5))
                .frame(height: geometry.size.height * 0.2)
                
            }
        }
    }
    
    
    
    
    //
    //CHILD VIEW
    //
    
    
    
    // SUMMARY: LIST ITEMS
    struct ListItemsView: View {
        @Binding var items: [ItemOrder]
        @State var isShowPopUpItemView = false
        
        var body: some View {
            List {
                ForEach($items) { $item in
                    VStack{
                        // line 1: item name & price
                        HStack {
                            Text("\(item.name)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(String(format: "$%.2f", item.price * Double(item.quantity)))
                                .frame(alignment: .trailing)
                                .foregroundColor(.gray)
                            
                        }
                        // line 2: Optional Note
                        HStack{
                            VStack{
                                if !item.noteAdd.isEmpty{
                                    Text("Add   : " + item.noteAdd)
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                if !item.noteRemove.isEmpty{
                                    Text("Remove: " + item.noteRemove)
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            if  !item.additionalFee.isZero{
                                Text("+" + String(format: "$%.2f", item.additionalFee * Double(item.quantity)))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .trailing)
                            }
                        }
                        
                        // line 3: QuantityItem and Stepper
                        HStack{
                            Text("Quantity: \(item.quantity)")
                            Stepper(String(item.quantity), value: $item.quantity, in: 1...10)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .fixedSize()
                                .labelsHidden()
                            
                            Text("Edit")
                                .onTapGesture(){
                                    isShowPopUpItemView.toggle()
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(.red)
                                .sheet(isPresented: $isShowPopUpItemView, content: {
                                    PopUpItemView(itemOrder: $item, isShow: $isShowPopUpItemView)
                                })
                        }
                    }
                }
                .onDelete { indexes in
                    for index in indexes{
                        items.remove(at: index)
                    }
                }
            }
            .listStyle(.plain)
            
        }
    }
    
    // SUMMARY: PRICES
    struct SummaryPriceView: View {
        var items: [ItemOrder]?
        
        var body: some View {
            let subTotal = calculateTotalPrice(items: items)
            HStack{
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                    if let tempItems = items{
                        Text(String(tempItems.count)).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    }
                    else {
                        Text("0").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    }
                    
                    Text("items")
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
                
                VStack(alignment: .leading) {
                    Text("Sub Total:")
                    Text("Tax(15%):")
                    Text("Total:")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity ,alignment: .center)
                
                VStack{
                    Text(String(format: "$%.2f", subTotal))
                    Text(String(format: "$%.2f", subTotal*0.15))
                    Text(String(format: "$%.2f", subTotal*1.15))
                        .font(.headline)
                }
                .frame(maxWidth: .infinity ,alignment: .trailing)
                
            }
            
        }
        
        
    }
    
    // SUMMARY: BUTTONS SECTION
    struct SummaryButtonView: View {
        @EnvironmentObject var orderStore: OrderStore
        
        @Binding var items:[ItemOrder]
        @Binding var time: Date
        @Binding var table: String
        
        //        @Environment(\.modelContext) private var context
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            HStack{
                Button(action: {
                    let order = Order()
                    order.orderNumber = generateOrderNumber()
                    order.time = time
                    order.dineIn = table
                    order.items = items
                    order.sendOrder = true
                    if order.dineIn == "TakeOut"{
                        order.pay = false
                    } else {
                        order.pay = true
                    }
                    order.pay = false
                    order.total = calculateTotalPrice(items: items)
                    //                    context.insert(order)
                    print(order)
                    orderStore.listOrders.append(order)
                    items = [] ; time = Date.now ; table = "TakeOut"
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Send order")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                    
                }
                
                
                
            }
        }
    }
    
    // POP-UP ITEM VIEW
    struct PopUpItemView: View {
        @Binding var itemOrder: ItemOrder
        @Binding var isShow: Bool
        
        @State private var selectedItems = Set<String>()
        let items = ["Item 1", "Item 2", "Item 3", "Item 4"]
        
        @State private var selectedItems2 = Set<String>()
        let items2 = ["Onions", "Hành", "Cà chua", "Tomato"]
        
        
        var body: some View {
            VStack {
                Text(itemOrder.name)
                    .font(.title).padding()
                //                Text(itemOrder.descriptions)
                //                    .font(.subheadline)
                //                    .padding()
                
                Text(String(format: "$%.2f", itemOrder.price))
                CustomStepper(value: $itemOrder.quantity)
                
                HStack {
                    List {
                        ForEach(items2, id: \.self) { item in
                            MultipleSelectionRow(title: item, isSelected: self.selectedItems2.contains(item), selectedColor: Color.red) {
                                if self.selectedItems2.contains(item) {
                                    self.selectedItems2.remove(item)
                                } else {
                                    self.selectedItems2.insert(item)
                                }
                            }
                        }
                    }
                    
                    List {
                        ForEach(items, id: \.self) { item in
                            MultipleSelectionRow(title: item, isSelected: self.selectedItems.contains(item), selectedColor: Color.green) {
                                if self.selectedItems.contains(item) {
                                    self.selectedItems.remove(item)
                                } else {
                                    self.selectedItems.insert(item)
                                }
                            }
                        }
                    }
                }
                
                // Button section
                HStack {
                    Button("Cancel") {
                        isShow = false
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
                    
                    Button("Confirm") {
                        isShow = false
                        itemOrder.noteAdd = selectedItems.joined(separator: ", ")
                        itemOrder.noteRemove = selectedItems2.joined(separator: ", ")
                        
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
                }
            }
        }
    }
    
    struct MultipleSelectionRow: View {
        var title: String
        var isSelected: Bool
        var selectedColor: Color
        var action: () -> Void
        var body: some View {
            Button(action: action) {
                HStack {
                    HStack{
                        Text(title) .padding()
                        Spacer()
                        Text("+$1")
                    }
                }
                .background(isSelected ? selectedColor : Color.clear)
                .foregroundColor(isSelected ? Color.white : Color.black)
                .cornerRadius(5)
            }
        }
    }
    
    
    
}



func hideKeyboard() {
    // Dismiss the keyboard
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}


//#Preview {
//    NewOrderView()
//        .environmentObject(OrderStore())
//}
