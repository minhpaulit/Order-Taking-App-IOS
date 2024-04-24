import Foundation


class ItemOrder: Identifiable, ObservableObject {
    let id = UUID()
    @Published var imageName: String
    @Published var name: String
    @Published var description: String
    @Published var allergy: Bool
    @Published var quantity: Int
    @Published var price: Double
    @Published var noteAdd: String
    @Published var noteRemove: String
    @Published var additionalFee: Double
    
    init(name: String, quantity: Int, price: Double, noteAdd: String, noteRemove: String, additionalFee: Double, imageName: String = "", description: String = "It's very delicious", allergy: Bool = false) {
        self.imageName = imageName
        self.name = name
        self.description = description
        self.allergy = allergy
        self.quantity = quantity
        self.price = price
        self.noteAdd = noteAdd
        self.noteRemove = noteRemove
        self.additionalFee = additionalFee
    }
    
    convenience init(name: String, price: Double) {
            self.init(name: name, quantity: 1, price: price, noteAdd: "", noteRemove: "", additionalFee: 0.0)
        }
    
    convenience init(name: String, price: Double, quantity: Int) {
            self.init(name: name, quantity: quantity, price: price, noteAdd: "", noteRemove: "", additionalFee: 0.0)
        }
    
    init(itemOrder: ItemOrder) {
            self.imageName = itemOrder.imageName
            self.name = itemOrder.name
            self.description = itemOrder.description
            self.allergy = itemOrder.allergy
            self.quantity = itemOrder.quantity
            self.price = itemOrder.price
            self.noteAdd = itemOrder.noteAdd
            self.noteRemove = itemOrder.noteRemove
            self.additionalFee = itemOrder.additionalFee
        }

}
