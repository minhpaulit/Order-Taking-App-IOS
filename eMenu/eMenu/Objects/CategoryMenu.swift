//
//  Category.swift
//  eMenu
//
//  Created by Minh Paul on 22/04/2024.
//

import Foundation

class CategoryMenu: Identifiable{
    var id = UUID()
    let name: String
    let items: [ItemOrder]
    
    init(name: String, items: [ItemOrder]) {
            self.name = name
            self.items = items
        }
}
