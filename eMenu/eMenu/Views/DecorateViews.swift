//
//  DecorateViews.swift
//  eMenu
//
//  Created by Minh Paul on 05/01/2024.
//

import SwiftUI


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

// Draw ssearch bar
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

