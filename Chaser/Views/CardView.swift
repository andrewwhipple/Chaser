//
//  CardView.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI

struct CardView: View {
    let recipe: Recipe

    @AppStorage("showAutomaticIngredientTags") private var showAutomaticIngredientTags = true
    
    private func getIngredientChips(ingredients: [Ingredient]) -> some View {
        var possibleIngredients = [String]()
        if showAutomaticIngredientTags {
            possibleIngredients = ["Rum", "Vodka", "Gin", "Tequila", "Mezcal", "Whisky", "Whiskey", "Scotch", "Rye", "Bourbon", "Cognac", "Brandy"]
        }
        
        
        var presentIngredients = [String]()
        
        for ingredient in possibleIngredients {
            let filteredIngredients = ingredients.filter { $0.name.localizedCaseInsensitiveContains(ingredient)}
            if !filteredIngredients.isEmpty {
                presentIngredients.append(ingredient)
            }
        }
        
        let result = ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(presentIngredients, id: \.self) { ingredient in
                    Chip(text: ingredient)
                }
                ForEach(recipe.tags, id: \.self) { tag in
                    Chip(text: tag)
                }
            }
        }
        
        return result
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.name).font(.headline)
            Spacer()
            getIngredientChips(ingredients: recipe.ingredients ?? [])
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
