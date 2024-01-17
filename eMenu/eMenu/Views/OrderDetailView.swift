//
//  OrderDetailView.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import SwiftUI
import SwiftData



struct Category: Identifiable{
    var id = UUID()
    let name: String
    let items: [ItemOrder]
}
    
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
    
    
    @State private var thisOrder = Order()
    
    @State private var itemOrders: [ItemOrder] = []
    
    @State private var selectedCategory = categories[0]
    
    @State private var isShowingDetail = false
    @State private var isTimePickerPresented = false
    
    let options = ["TakeOut", "Table 1", "Table 2", "Table 3", "Table 4", "Table 5", "Table 6", "Table 7", "Table 8", "Table 9", "Table 10", "Table 11", "Table 12", "Table 13"]
    
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
                NavigationStack{
                    List(selectedCategory.items){ item in
                        Button(action: {
                            let item = ItemOrder(name: item.name, price: item.price)
                            itemOrders.append(item)
                            print("acc")
                        }){
                            HStack{
                                Text(item.name)
                                if !item.alergy{
                                    Image(systemName: "leaf")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .background(Color(UIColor.systemGray6))
            }
            .background(Color(UIColor.systemGray6))
            .frame(maxHeight: .infinity)
            .frame(width: UIScreen.main.bounds.width * 0.3)
            .padding(5)
            .cornerRadius(25)
            
                
            // RIGHT COLUMN: summary
            VStack{
                Spacer().frame(height: 10)
                Text("Summary").font(.title)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/ ,alignment: .center)
                Divider()
                
                if !itemOrders.isEmpty {
                    // Summary: List Item View
                    SummaryItemsView(items: $itemOrders)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    Divider()
                    // Summary: Total Money View
                    SummaryTotalView(items: $itemOrders)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                Spacer()
                Divider()
                
                // Summary column: Time and takeOut
                HStack{
                    // TakeOut picker
                    Picker("Select the table", selection: $thisOrder.dineIn) {
                            ForEach(options, id: \.self) { option in
                                Text(option)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(maxWidth: .infinity, maxHeight: 50) // Adjust size as needed

                    // time picker
                    VStack{
                        DatePicker("Time", selection: $thisOrder.time, displayedComponents: .hourAndMinute)
                            .datePickerStyle(DefaultDatePickerStyle())
                            .labelsHidden()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .disabled(thisOrder.dineIn != "TakeOut")
                        if thisOrder.time < Date.now && thisOrder.dineIn == "TakeOut"{
                            Text("Over Due!")
                                .foregroundColor(.red)
                        }
                    }
                }
                .background(Color(UIColor.systemGray5))
                Divider()
                
                // Summary Button View
                SummaryButtonView(order:$thisOrder, items: itemOrders)
                    .frame(maxWidth: .infinity, alignment: .bottom)
                                    .padding()
            }
            .background(Color(UIColor.systemGray6))
            .frame(maxHeight: .infinity)
            .frame(width: UIScreen.main.bounds.width * 0.5)
            .padding(5)
            .cornerRadius(25)
            
        }
        .background(Color(UIColor.systemGray5))
    }
    
    

    // SUMMARY: ITEMS
    struct SummaryItemsView: View {
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
    // SUMMARY: TOTAL SECTION
    struct SummaryTotalView: View {
        @Binding var items: [ItemOrder]
        
        var body: some View {
            let subTotal = calculateTotalPrice()
            HStack{
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                    Text(String(items.count)).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
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
            for item in items {
                totalPrice += (item.price + item.additionalFee) * Double(item.quantity)
            }
            return totalPrice
        }
    }

    // SUMMARY: BUTTONS SECTION
    struct SummaryButtonView: View {
        @Binding var order:Order
        var items:[ItemOrder]
        @Environment(\.modelContext) private var context
        @Environment(\.presentationMode) var presentationMode
        
        
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
                    order.items = items
                    order.orderNumber = generateOrderNumber()
                    // send order
                    order.sendOrder = true
                    // print bill
                    order.printBill = true
                    context.insert(order)
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
    
    // POP-UP ITEM VIEW
    struct PopUpItemView: View {
        @Binding var itemOrder: ItemOrder
        @Binding var isShow: Bool
        
        @State private var numberText:String = " "
        
                
        var body: some View {
            VStack {
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
                       isShow = false
                   }
                   .padding()
                   .foregroundColor(.white)
                   .background(Color.red)
                   .cornerRadius(8)
                   
                   Button("Confirm") {
                       isShow = false
                   }
                   .padding()
                   .foregroundColor(.white)
                   .background(Color.green)
                   .cornerRadius(8)
               }
            }
//            .padding()
//            .frame(maxWidth: .infinity)
//            .frame(width: UIScreen.main.bounds.width * 0.3)
//            .frame(height: UIScreen.main.bounds.height * 0.3)
        }
    }
}


#Preview {
    OrderDetailView()
}
