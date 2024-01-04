//
//  ContentView.swift
//  eMenu
//
//  Created by Minh Paul on 01/01/2024.
//

import SwiftUI


struct Order: Identifiable {
    let id = UUID()
    let orderNumber: String
    let customerName: String
    var items: [ItemOrder]
    var total: Double
    var time: Date
    var dineIn: String
    var printBill: Bool
    var sendOrder: Bool
    
    init(orderNumber: String, customerName: String, items: [ItemOrder], total: Double, time: Date, dineIn: Bool, printBill: Bool, sendOrder: Bool) {
        self.orderNumber = orderNumber
        self.customerName = customerName
        self.items = items
        self.total = total
        self.time = time
        self.dineIn = "TakeOut"
        self.printBill = printBill
        self.sendOrder = sendOrder
    }
    
    init(){
        self.orderNumber = ""
        self.customerName = ""
        self.items  = []
        self.total = 0
        self.time = Date.now
        self.dineIn = "1"
        self.printBill = false
        self.sendOrder = false
    }
    
    
}

struct Category: Identifiable{
    var id = UUID()
    let name: String
    let items: [ItemOrder]
}

//struct Dish: Identifiable {
//    let id = UUID()
//    var discription = "It's very delicious"
//    let name: String
//    let price: Double
//    let alergy = false
//}

struct ItemOrder: Identifiable{
    let id = UUID()
    let imageName: String
    var name: String
    let description = "It's very delicious"
    let alergy = false
    var quantity: Int
    var price: Double
    var noteAdd: String
    var noteRemove: String
    var additionalFee: Double
    var image: Image {
        if imageName.isEmpty{
            Image(systemName: "star")
        }
        else{
            Image(imageName)
        }
    }
    
    init() {
        self.imageName = ""
        self.name = ""
        self.quantity = 1
        self.price = 0.0
        self.noteAdd = ""
        self.noteRemove = ""
        self.additionalFee = 0.0
    }
    
    init(name: String, price: Double) {
        self.imageName = ""
        self.name = name
        self.quantity = 1
        self.price = price
        self.noteAdd = ""
        self.noteRemove = ""
        self.additionalFee = 0.0
    }
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

    
    private var all_dishes = [
        ItemOrder(name: "Fries", price: 4.99),
        ItemOrder(name: "Chicken Ball", price: 4.99),
        ItemOrder(name: "Wontons", price: 4.99),
        ItemOrder(name: "Egg Rolls", price: 4.99),
        ItemOrder(name: "Wings", price: 5.99),
        ItemOrder(name: "Shrims", price: 6.99),
        ItemOrder(name: "Crabs", price: 7.99),
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


//    === end meta_data

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
            
                itemOrder.image
                Text(itemOrder.name)
                    .font(.headline)
                Text(itemOrder.description)
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
    ContentView()
//    OrderDetailView()
}
