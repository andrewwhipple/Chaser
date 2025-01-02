//
//  Recipe.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import Foundation
import SwiftData


@Model
final class Recipe {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var updatedAt: Date
    
    var name: String
    var ingredients: Array<Ingredient>
    var instructions: String
    
    init(name: String, ingredients: Array<Ingredient>, instructions: String) {
        self.id = UUID()
        self.createdAt = Date()
        self.updatedAt = Date()
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
    }
}

extension Recipe {
    static var emptyRecipe: Recipe {
        Recipe(name: "", ingredients: [], instructions: "")
    }
    
    static var sampleRecipes: [Recipe] {
        [
            Recipe(
                name: "Mai Tai",
                ingredients: [
                    Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                    Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.25),
                    Ingredient(name: "orgeat", unit: Ingredient.Unit.ounce, amount: 0.25),
                    Ingredient(name: "curaçao", unit: Ingredient.Unit.ounce, amount: 0.5),
                    Ingredient(name: "jamaican rum", unit: Ingredient.Unit.ounce, amount: 2)
                ],
                instructions: "Shake with pebble ice and lime shell. Garnish with spent lime shell and mint sprig"
            ),
            Recipe(
                name: "Martini",
                ingredients: [
                    Ingredient(name: "dry vermouth", unit: Ingredient.Unit.ounce, amount: 0.5),
                    Ingredient(name: "gin", unit: Ingredient.Unit.ounce, amount: 2.5)
                ],
                instructions: "Stir, serve up with either olive or lemon twist"
            ),
            Recipe(
                name: "Margarita",
                ingredients: [
                    Ingredient(name: "lime juice", unit: Ingredient.Unit.ounce, amount: 0.75),
                    Ingredient(name: "simple syrup", unit: Ingredient.Unit.ounce, amount: 0.75),
                    Ingredient(name: "tequila", unit: Ingredient.Unit.ounce, amount: 0.25)
                ],
                instructions: "Shake, serve on the rocks"
            )
        ]
    }
}

