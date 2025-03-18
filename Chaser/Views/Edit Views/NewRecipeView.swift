//
//  NewRecipe.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI

struct NewRecipeView: View {
    @State private var newRecipe = Recipe.emptyRecipe
    @Binding var recipes: [Recipe]
    @Binding var isPresentingNewRecipeView: Bool
    
    var body: some View {
        NavigationStack {
            DetailEditView(recipe: $newRecipe)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Dismiss") {
                            isPresentingNewRecipeView = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            recipes.append(newRecipe)
                            isPresentingNewRecipeView = false
                        }
                    }
                }
        }
    }
}


struct NewRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecipeView(recipes: .constant(Recipe.sampleRecipes), isPresentingNewRecipeView: .constant(true))
    }
}
