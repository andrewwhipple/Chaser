//
//  SampleDetailView.swift
//  Chaser
//
//  Created by Andrew Whipple on 2/6/26.
//

import SwiftUI

struct SampleDetailView: View {
    let sampleRecipe: Recipe
    @Binding var recipes: [Recipe]
    @Environment(\.modelContext) private var modelContext
    
    // Check if this sample recipe has already been added to the user's library
    private var isRecipeInLibrary: Bool {
        recipes.contains { $0.sourceRecipeId == sampleRecipe.id }
    }
    
    // Add the sample recipe to the user's library
    private func addToLibrary() {
        let newRecipe = Recipe(
            name: sampleRecipe.name,
            ingredients: (sampleRecipe.ingredients ?? []).map { ingredient in
                Ingredient(name: ingredient.name, unit: ingredient.unit, amount: ingredient.amount)
            },
            instructions: sampleRecipe.instructions,
            tags: sampleRecipe.tags,
            sourceRecipeId: sampleRecipe.id
        )
        modelContext.insert(newRecipe)
    }
    
    var body: some View {
        List {
            Section(header: Text("Ingredients")) {
                ForEach(sampleRecipe.ingredients ?? []) { ingredient in
                    Text(ingredient.description)
                }
            }
            Section(header: Text("Instructions")) {
                Text(sampleRecipe.instructions)
            }
        }
        .navigationTitle(sampleRecipe.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: addToLibrary) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("Add to Library")
                    }
                }
                .disabled(isRecipeInLibrary)
                .accessibilityLabel(isRecipeInLibrary ? "Already in library" : "Add to library")
            }
        }
    }
}

struct SampleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SampleDetailView(
                sampleRecipe: Recipe.sampleRecipes[0],
                recipes: .constant([])
            )
        }
    }
}
