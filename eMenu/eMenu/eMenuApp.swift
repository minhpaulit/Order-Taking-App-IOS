//
//  eMenuApp.swift
//  eMenu
//
//  Created by Minh Paul on 01/01/2024.
//

import SwiftUI
import SwiftData

@main
struct eMenuApp: App {
    let modelContainer: ModelContainer
            
        init() {
            do {
                modelContainer = try ModelContainer(for: ItemOrder.self, Order.self)
            } catch {
                fatalError("Could not initialize ModelContainer")
            }
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
