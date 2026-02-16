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
    @Environment(\.modelContext) private var modelContext
    
    private var isValidRecipe: Bool {
        !newRecipe.name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !(newRecipe.ingredients ?? []).isEmpty
    }
    
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
                            modelContext.insert(newRecipe)
                            isPresentingNewRecipeView = false
                        }
                        .disabled(!isValidRecipe)
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
