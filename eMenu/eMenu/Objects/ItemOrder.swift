import Foundation

class ItemOrder: Identifiable {
    let id = UUID()
    let imageName: String
    var name: String
    let description: String
    let allergy: Bool
    var quantity: Int
    var price: Double
    var noteAdd: String
    var noteRemove: String
    var additionalFee: Double
    
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
