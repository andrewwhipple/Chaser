//
//  ContentView.swift
//  Chaser
//
//  Created by GitHub Copilot on 2/16/26.
//

import SwiftUI
import SwiftData
import CloudKit
import OSLog

/// Bridge view that connects SwiftData (with CloudKit) to the existing RecipesView
struct ContentView: View {
    // SwiftData automatically loads and syncs with CloudKit!
    @Query(sort: [SortDescriptor(\Recipe.updatedAt, order: .reverse)]) private var recipes: [Recipe]
    @Environment(\.modelContext) private var modelContext
    
    @Binding var pendingRecipeImport: Recipe?
    
    var body: some View {
        RecipesView(
            recipes: Binding(
                get: { recipes },
                set: { (_: [Recipe]) in /* SwiftData auto-saves */ }
            )
        )
        .environment(\.modelContext, modelContext)
        .onChange(of: pendingRecipeImport) { oldValue, newValue in
            if let recipe = newValue {
                importRecipe(recipe)
                // Clear the pending import
                pendingRecipeImport = nil
            }
        }
    }
    
    private func importRecipe(_ recipe: Recipe) {
        // Create a new recipe with new UUID (since the shared recipe doesn't include UUID)
        let newRecipe = Recipe(
            name: recipe.name,
            ingredients: (recipe.ingredients ?? []).map { ingredient in
                Ingredient(
                    name: ingredient.name,
                    unit: ingredient.unit,
                    amount: ingredient.amount
                )
            },
            instructions: recipe.instructions,
            tags: recipe.tags
        )
        
        modelContext.insert(newRecipe)
        Logger.storage.info("Successfully imported recipe from URL: \(newRecipe.name)")
    }
}
