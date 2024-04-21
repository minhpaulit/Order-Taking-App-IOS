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
struct NewOrderView: View {
    
//    @State private var thisOrder = Order()
    
    @State private var itemOrders: [ItemOrder] = []
    @State private var time = Date()
    @State private var table: String = "TakeOut"
    @State private var notes: String = ""
    
    @State private var selectedCategory = categories[0]
    
    
    let options = ["TakeOut", "Table 1", "Table 2", "Table 3", "Table 4", "Table 5", "Table 6", "Table 7", "Table 8", "Table 9", "Table 10", "Table 11", "Table 12", "Table 13"]
    
    var body: some View {
        VStack{
            
            // SECTION 1
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
                    List(selectedCategory.items){ item in
                        Button(action: {
                            let item = ItemOrder(name: item.name, price: item.price)
                            itemOrders.append(item)
                        }){
                            HStack{
                                Text(item.name)
                                Spacer()
                                if !item.alergy{
                                    Image(systemName: "leaf")
                                        
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                .background(Color(UIColor.systemGray6))
                .frame(maxHeight: .infinity)
                .frame(width: UIScreen.main.bounds.width * 0.3)
                .padding(5)
                .cornerRadius(25)
                
                
                // RIGHT COLUMN: summary
                VStack{
                    Spacer().frame(height: 10)
                    Text("Summary").font(.title) .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/ ,alignment: .center)
                    Spacer()
                    Divider()
                    if !itemOrders.isEmpty {
                        // Summary: List Item View
                        ListItemsView(items: $itemOrders)
                            .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    
                    
                }
                .background(Color(UIColor.systemGray6))
                .frame(maxHeight: .infinity)
                .frame(width: UIScreen.main.bounds.width * 0.5)
                .padding(5)
                .cornerRadius(25)
                
            }
            .background(Color(UIColor.systemGray5))
            .frame(height: UIScreen.main.bounds.height * 0.75)
            
            
            // SECTION 2
            HStack(spacing: 0) {
                // Column 1
                VStack{
                    
                    
                    Text("Order: #005-240709").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        
                    TextField("Enter Notes Here", text: $notes).font(.system(size: 20))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal)
                    HStack{
                            
                            // TakeOut Picker
                            Picker("Select the table", selection: $table) {
                                    ForEach(options, id: \.self) { option in Text(option) } }
                                .pickerStyle(WheelPickerStyle())
                                .frame(maxWidth: .infinity, maxHeight: 100) // Adjust size as needed
                                .frame(width: UIScreen.main.bounds.width * 0.2)
                            Spacer()
                        
                            if time < Date.now && table == "TakeOut"{
                                Text("Over Due!")
                                    .foregroundColor(.red)
                                }
                            // Time Picker
                            DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)
                                .datePickerStyle(DefaultDatePickerStyle())
                                .labelsHidden()
                                .disabled(table != "TakeOut")
                            
                            

                    }.padding(.horizontal)
                    
                    Spacer()
                }
                .background(Color(UIColor.systemGray6))
                .frame(width: UIScreen.main.bounds.width * 0.5)
                .padding(5)
                .cornerRadius(25)
                
                
                // Column 2
                VStack{
                    SummaryPriceView(items: itemOrders).padding()
                    Divider()
                    SummaryButtonView(items: $itemOrders, time: $time, table: $table) .padding()
                }
                .background(Color(UIColor.systemGray6))
                .frame(width: UIScreen.main.bounds.width * 0.5)
                .padding(5)
                .cornerRadius(25)
                
                
            }
            .background(Color(UIColor.systemGray5))
            .frame(height: UIScreen.main.bounds.height * 0.25)
            
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
        
        @Binding var items:[ItemOrder]
        @Binding var time: Date
        @Binding var table: String
        @Environment(\.modelContext) private var context
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            HStack{
                Button("   Reset   ") {
                    items = [] ; time = Date.now ; table = "TakeOut"
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Button("Send Order") {
                    let order = Order()
                    order.orderNumber = generateOrderNumber()
                    order.time = time
                    order.dineIn = table
                    order.items = items
                    order.sendOrder = true
                    if order.dineIn == "TakeOut"{
                        order.printBill = false
                    } else {
                        order.printBill = true
                    }
                    order.printBill = false
                    order.total = calculateTotalPrice(items: items)
                    context.insert(order)
                    print(order)
                    items = [] ; time = Date.now ; table = "TakeOut"
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
                
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
                Text(itemOrder.descriptions)
                    .font(.subheadline)
                    .padding()
                
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

// Function to calculate total price of items
func calculateTotalPrice(items: [ItemOrder]?) -> Double {
    if let tempItems = items{
        var totalPrice = 0.0
        for item in tempItems {
            totalPrice += (item.price + item.additionalFee) * Double(item.quantity)
        }
        return totalPrice
    } else {
        return 0
    }
}


#Preview {
    NewOrderView()
}
