//
//  DetailView.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI

struct DetailView: View {
    @Binding var recipe: Recipe
    
    @State private var editingRecipe = Recipe.emptyRecipe
    @State private var isPresentingEditView = false
    
    var body: some View {
        List {
            Section(header: Text("Ingredients")) {
                ForEach(recipe.ingredients) { ingredient in
                    Text(ingredient.description)
                }
            }
            Section(header: Text("Instructions")) {
                Text(recipe.instructions)
            }
        }
        .navigationTitle(recipe.name)
        .toolbar {
            Button(action: shareRecipe) {
                Image(systemName: "square.and.arrow.up")
            }
            .accessibilityLabel("Share recipes")
            Button("Edit") {
                isPresentingEditView = true
                editingRecipe = recipe
            }
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
                                recipe = editingRecipe
                            }
                        }
                    }
            }
        }
    }
    
    private func shareRecipe() {
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
