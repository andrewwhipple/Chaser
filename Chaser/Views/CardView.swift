//
//  CardView.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI

struct CardView: View {
    let recipe: Recipe
    
    private func ingredientChip(_ ingredient: String) -> some View {
        Text(ingredient)
            .padding(5)
            .foregroundColor(.secondary)
            .background(Color.secondary.opacity(0.2))
            .cornerRadius(5)
    }

    private func getIngredientChips(ingredients: [Ingredient]) -> some View {
        let possibleIngredients = ["Rum", "Vodka", "Gin", "Tequila", "Mezcal", "Whisky", "Whiskey", "Scotch", "Rye", "Bourbon"]
        
        var presentIngredients = [String]()
        
        for ingredient in possibleIngredients {
            let filteredIngredients = ingredients.filter { $0.name.localizedCaseInsensitiveContains(ingredient)}
            if !filteredIngredients.isEmpty {
                presentIngredients.append(ingredient)
            }
        }
        
        let result = HStack {
            ForEach(presentIngredients, id: \.self) { ingredient in
                ingredientChip(ingredient)
            }
        }
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.name).font(.headline)
            Spacer()
            getIngredientChips(ingredients: recipe.ingredients)
            .font(.caption)
        }
        .padding()
    }
}




struct CardView_Previews: PreviewProvider {
    static var recipe = Recipe.sampleRecipes[0]
    static var previews: some View {
        CardView(recipe: recipe)
    }
}
