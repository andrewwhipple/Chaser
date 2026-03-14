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
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    @Query(sort: [SortDescriptor(\Recipe.updatedAt, order: .reverse)]) private var recipes: [Recipe]
    @Environment(\.modelContext) private var modelContext
    
    @Binding var pendingRecipeImport: Recipe?
    
    var body: some View {
        //Text("Products loaded: \(purchaseManager.productsLoaded)")
        //Text("Products: \(purchaseManager.products)")
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
                pendingRecipeImport = nil
            }
        }.task {
            do {
                try await purchaseManager.loadProducts()
            } catch {
                Logger.iap.error("Error loading products: \(error.localizedDescription)")
            }
        }
    }
    
    private func importRecipe(_ recipe: Recipe) {
  
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
