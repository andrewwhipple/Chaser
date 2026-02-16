//
//  DetailView.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI
import CloudKit
import OSLog

struct DetailView: View {
    @Binding var recipe: Recipe
    
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var store: RecipeStore
    
    @State private var editingRecipe = Recipe.emptyRecipe
    @State private var isPresentingEditView = false
    
    var body: some View {
        List {
            Section(header: Text("Ingredients")) {
                ForEach(recipe.ingredients ?? []) { ingredient in
                    Text(ingredient.description)
                }
            }
            Section(header: Text("Instructions")) {
                Text(recipe.instructions)
            }
            Section(header: Text("Tags")) {
                ForEach(recipe.tags, id: \.self) { tag in
                    Chip(text: tag)
                }
            }
        }
        .navigationTitle(recipe.name)
        .toolbar {
            Button(action: shareRecipeURL) {
                Image(systemName: "square.and.arrow.up")
            }
            .accessibilityLabel("Share \(recipe.name)")
            .accessibilityHint("Share this recipe with friends")
            Button("Edit") {
                editingRecipe = recipe.copy()
                isPresentingEditView = true
            }
            .accessibilityHint("Edit recipe details, ingredients, and instructions")
        }
        .sheet(isPresented: $isPresentingEditView) {
            NavigationStack {
                DetailEditView(recipe: $editingRecipe)
                    .navigationTitle(recipe.name)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditView = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditView = false
                                // Update properties of the original recipe (SwiftData-tracked)
                                // instead of replacing the entire object
                                recipe.name = editingRecipe.name.trimmingCharacters(in: .whitespaces)
                                recipe.instructions = editingRecipe.instructions
                                recipe.tags = editingRecipe.tags
                                recipe.updatedAt = Date()
                                
                                // For ingredients, we need to remove old ones and add new ones
                                // because they are separate SwiftData entities
                                recipe.ingredients?.removeAll()
                                if let newIngredients = editingRecipe.ingredients {
                                    for editedIngredient in newIngredients {
                                        let newIngredient = Ingredient(
                                            name: editedIngredient.name,
                                            unit: editedIngredient.unit,
                                            amount: editedIngredient.amount
                                        )
                                        recipe.ingredients?.append(newIngredient)
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    // MARK: - URL-based Recipe Sharing
    func shareRecipeURL() {
        guard let shareURL = RecipeURLSharing.createShareURL(from: recipe) else {
            Logger.storage.error("Failed to create shareable URL for recipe: \(recipe.name)")
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareURL],
            applicationActivities: nil
        )
        
        // Present the share sheet
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = scene.windows.first?.rootViewController {
            // For iPad, we need to configure the popover
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = rootViewController.view
                popoverController.sourceRect = CGRect(
                    x: rootViewController.view.bounds.midX,
                    y: rootViewController.view.bounds.midY,
                    width: 0,
                    height: 0
                )
                popoverController.permittedArrowDirections = []
            }
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Legacy JSON Export (kept for reference, no longer in UI)
    func shareRecipeJSON() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        if let jsonData = try? encoder.encode([recipe]),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Recipes-\(recipe.id)-\(UUID()).json")
            try? jsonString.write(to: tempURL, atomically: true, encoding: .utf8)
            
            let activityViewController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = scene.windows.first?.rootViewController {
                rootViewController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(recipe: .constant(Recipe.sampleRecipes[0]))
        }
    }
}
