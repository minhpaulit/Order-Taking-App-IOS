//
//  OrderDetailView.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import SwiftUI



struct Category: Identifiable{
    var id = UUID()
    let name: String
    let items: [ItemOrder]
}

//    === meta_data
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
    
private var category_single = Category(name: "Dishes", items: [
    ItemOrder(name: "#1", price: 4.99),
    ItemOrder(name: "#2", price: 4.98),
    ItemOrder(name: "#3", price: 4.97),
])
private var category_combo = Category(name: "Combo", items: [
    ItemOrder(name: "Combo 1", price: 4.99),
    ItemOrder(name: "Combo 12", price: 4.98),
    ItemOrder(name: "Combo 13", price: 4.97),
])
private var category_dinner = Category(name: "Dinner", items: [
    ItemOrder(name: "Dinner 1", price: 4.99),
    ItemOrder(name: "Dinner 2", price: 4.98),
    ItemOrder(name: "Dinner 3", price: 4.97),
])
private var categories = [category_combo, category_dinner, category_single]


//NEW ORDER BIG VIEW
struct OrderDetailView: View {
    @State private var selectedCategory = categories[0]
    @State private var selectedItem: ItemOrder? = nil
    @State private var thisOrder = Order()
    @State private var isShowingDetail = false
    @State private var isTimePickerPresented = false
    
    let options = ["TakeOut", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13"]
    
    var body: some View {
        
        
        HStack(spacing: 0) {
            // LEFT COLUMN: list Category
            VStack{
                List(categories) { category in
                    Button(action: {
                            selectedCategory = category
                        
                        }) {
                            HStack() {
                                Text(category.name)
                                    .font(.headline)
                                Spacer()
                                Text("\(category.items.count)")
                                    .font(.subheadline)
                            }
                        }
                }
                .listStyle(PlainListStyle())
            }
            .background(Color(UIColor.systemGray6))
            .frame(maxWidth: .infinity)
            .frame(width: UIScreen.main.bounds.width * 0.2)
            .padding(5)
            .cornerRadius(25)
            
            
            // MIDDLE COLUMN: list items
            VStack{
                List(selectedCategory.items) { item in
                    Button(action: {
                        selectedItem = ItemOrder(name: item.name, price: item.price)
                        isShowingDetail = true
                    }) {
                        Text(item.name)
                    }
                }
                .listStyle(.plain)
                .sheet(isPresented: $isShowingDetail) {
                    ItemDetailView(itemOrder: Binding(
                        get: { selectedItem ?? ItemOrder() }, set: { selectedItem = $0 }
                    ), order: $thisOrder, isPresented: $isShowingDetail)
                }

            }
            .background(Color(UIColor.systemGray6))
            .frame(maxHeight: .infinity)
            .frame(width: UIScreen.main.bounds.width * 0.4)
            .padding(5)
            .cornerRadius(25)
            
                
            // RIGHT COLUMN: summary
            VStack{
                Spacer().frame(height: 10)
                
                // Header summary
                HStack{
                    // choose table
                    Picker("Select an option", selection: $thisOrder.dineIn) {
                            ForEach(options, id: \.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity, maxHeight: 70) // Adjust size as needed

                    Text("Summary").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/ ,alignment: .center)
                    
                    // choose time if takeout
                    VStack{
                        DatePicker("Time", selection: $thisOrder.time, displayedComponents: .hourAndMinute)
                            .datePickerStyle(DefaultDatePickerStyle())
                            .labelsHidden()
                            .fixedSize()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .disabled(thisOrder.dineIn != "TakeOut")
                        if thisOrder.time < Date.now && thisOrder.dineIn == "TakeOut"{
                            Text("Over Due!")
                                .foregroundColor(.red)
                        }
                    }
                }
                Divider()
                
                
                if !thisOrder.items.isEmpty {
                    SummaryItemsView(order: $thisOrder)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    Divider()
                    SummaryTotalView(order: $thisOrder)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                } else {
                    Text("No items")
                    Spacer()
                }
                
                Divider()
                SummaryButtonView(order:$thisOrder)
                    .frame(maxWidth: .infinity, alignment: .bottom)
                                    .padding()
                
            }
            .background(Color(UIColor.systemGray6))
            .frame(maxHeight: .infinity)
            .frame(width: UIScreen.main.bounds.width * 0.4)
            .padding(5)
            .cornerRadius(25)
            
        }
        .background(Color(UIColor.systemGray5))
    }
    
    
    // POP-UP ITEM VIEW
    struct ItemDetailView: View {
        @Binding var itemOrder: ItemOrder
        @Binding var order: Order
        @Binding var isPresented: Bool
        @State private var numberText: String = ""
        
        var body: some View {
            VStack {
            
                Image(systemName: "star")
                Text(itemOrder.name)
                    .font(.headline)
                Text(itemOrder.descriptions)
                    .font(.subheadline)
                    .padding()
                
                Text(String(format: "$%.2f", itemOrder.price))
                CustomStepper(value: $itemOrder.quantity)
                
                TextField("Add", text: $itemOrder.noteAdd)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Remove", text: $itemOrder.noteRemove)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Surcharge", text: $numberText)
                    .keyboardType(.decimalPad)
                    .onChange(of: numberText, initial: true) { _,_  in
                        if let value = Double(numberText) {
                            itemOrder.additionalFee = value
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Button section
                HStack {
                   Button("Cancel") {
                       isPresented = false
                   }
                   .padding()
                   .foregroundColor(.white)
                   .background(Color.red)
                   .cornerRadius(8)
                   
                   Button("Confirm") {
                       isPresented = false
                       order.items.append(itemOrder)
                   }
                   .padding()
                   .foregroundColor(.white)
                   .background(Color.green)
                   .cornerRadius(8)
               }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(width: UIScreen.main.bounds.width * 0.3)
            .frame(height: UIScreen.main.bounds.height * 0.3)
        }
    }

    // SUMMARY: ITEMS
    struct SummaryItemsView: View {
//        @Binding var lstItems: [ItemOrder]
        @Binding var order: Order
        
        var body: some View {
            List {
                ForEach($order.items) { $item in
                    VStack{
                        // line 1: item name & price
                        HStack {
                            Text("\(item.name) Chicken Ball")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(String(format: "$%.2f", item.price * Double(item.quantity)))
                                .frame(alignment: .trailing)
                                .foregroundColor(.gray)

                        }
                        // line 2: Optional Note
                        HStack{
                            VStack{
                                if !item.noteAdd.isEmpty{
                                    Text("Add:" + item.noteAdd)
                                        .foregroundColor(.red)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                if !item.noteRemove.isEmpty{
                                    Text("Remove:" + item.noteRemove)
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
                        
                        // line 3: Quantity and Stepper
                        HStack{
                            Text("Quantity: \(item.quantity)")
                            Stepper(String(item.quantity), value: $item.quantity, in: 1...10)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .fixedSize()
                                .labelsHidden()
                            
                            Text("Remove")
                                .onTapGesture(){
                                    if let index = order.items.firstIndex(where: { $0.id == item.id }) {
                                        order.items.remove(at: index)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(.red)
                            
                        }
                    }
                }
            }
            .listStyle(.plain)
           
        }
    }
    // SUMMARY: TOTAL SECTION
    struct SummaryTotalView: View {
        @Binding var order: Order
        
        var body: some View {
            let subTotal = calculateTotalPrice()
            HStack{
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                    Text(String(order.items.count)).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
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
        // Function to calculate total price of items
        func calculateTotalPrice() -> Double {
            var totalPrice = 0.0
            for item in order.items {
                totalPrice += (item.price + item.additionalFee) * Double(item.quantity)
            }
            return totalPrice
        }
    }

    // SUMMARY: BUTTONS SECTION
    struct SummaryButtonView: View {
        @Environment(\.presentationMode) var presentationMode
        @Binding var order:Order
        var body: some View {
            HStack{
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                .frame(minWidth: 0, maxWidth: .infinity)
                
                
                Button("Print Bill") {
                    // send order
                    order.sendOrder = true
                    // print bill
                    order.printBill = true
                    
                    print(order)
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .frame(minWidth: 0, maxWidth: .infinity)
                
                Button("Send Order") {
                    order.sendOrder = true
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                .frame(minWidth: 0, maxWidth: .infinity)
                .disabled(order.sendOrder == true)
            }
        }
    }
}

// ================
//      CSS
// ================
struct CustomStepper: View {
    @Binding var value: Int
    var body: some View {
        HStack {
            Button(action: {
                if self.value > 0 {
                    self.value -= 1
                }
                
            }) {
                Image(systemName: "minus.square.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                    
            }
            .padding()

            Text("\(value)")
                .font(.title)

            Button(action: {
                self.value += 1
            }) {
                
                Image(systemName: "plus.square.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 25))
                    
                
            }
            .padding()
        }
    }
}

#Preview {
    OrderDetailView()
}
