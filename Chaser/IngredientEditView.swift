//
//  IngredientEditView.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI

struct IngredientEditView: View {
    @Binding var ingredient: Ingredient
    
    @State private var amountMajor = 0.0
    @State private var amountMinor = 0.0
    
    private var totalAmount: Double {
        return amountMajor + amountMinor
    }

    var body: some View {
        Form {
            TextField("Ingredient name", text: $ingredient.name)
            HStack {
                // TODO fix that it doesnt sync back from the binding to amount
                
                Picker("Amount", selection: $amountMajor) {
                    ForEach(0..<11, id: \.self) { i in
                        Text("\(i)").tag(Double(i))
                    }
                }
                
                Picker("", selection: $amountMinor) {
                    Text("0").tag(0.0)
                    Text("1/8").tag(0.125)
                    Text("1/4").tag(0.25)
                    Text("3/8").tag(0.375)
                    Text("1/2").tag(0.5)
                    Text("5/8").tag(0.625)
                    Text("3/4").tag(0.75)
                    Text("7/8").tag(0.875)
                }
            }
            .onChange(of: amountMajor) {
                ingredient.amount = totalAmount
            }
            .onChange(of: amountMinor) {
                ingredient.amount = totalAmount
            }
            Picker("", selection: $ingredient.unit) {
                Text("oz").tag(Ingredient.Unit.ounce)
                Text("ml").tag(Ingredient.Unit.milliliter)
                Text("dash").tag(Ingredient.Unit.dash)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .onAppear {
            amountMajor = floor(ingredient.amount)
            amountMinor = ingredient.amount - floor(ingredient.amount)
        }
    }
}

struct IngredientEditView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientEditView(ingredient: .constant(Ingredient(name: "", unit: Ingredient.Unit.ounce, amount: 0)))
    }
}
