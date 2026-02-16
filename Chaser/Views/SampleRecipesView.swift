//
//  SampleRecipesView.swift
//  Chaser
//
//  Created by Andrew Whipple on 2/6/26.
//

import SwiftUI

struct SampleRecipesView: View {
    @Binding var recipes: [Recipe]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    private let sampleLibrary = SampleRecipeLibrary.shared
    
    // Check if a sample recipe has already been added to the user's library
    private func isRecipeInLibrary(sampleRecipe: Recipe) -> Bool {
        recipes.contains { $0.sourceRecipeId == sampleRecipe.id }
    }
    
    // Add a sample recipe to the user's library
    private func addToLibrary(sampleRecipe: Recipe) {
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
        NavigationStack {
            List {
                ForEach(sampleLibrary.sections, id: \.title) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.recipes, id: \.id) { recipe in
                            recipeRow(for: recipe)
                        }
                    }
                }
            }
            .navigationTitle("Inspiration")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Recipes")
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func recipeRow(for recipe: Recipe) -> some View {
        HStack {
            NavigationLink(destination: SampleDetailView(
                sampleRecipe: recipe,
                recipes: $recipes
            )) {
                CardView(recipe: recipe)
            }
            
            Spacer()
            
            Button(action: {
                addToLibrary(sampleRecipe: recipe)
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(isRecipeInLibrary(sampleRecipe: recipe) ? .gray : .accentColor)
            }
            .buttonStyle(BorderlessButtonStyle())
            .disabled(isRecipeInLibrary(sampleRecipe: recipe))
            .accessibilityLabel(isRecipeInLibrary(sampleRecipe: recipe) ? "Already in library" : "Add to library")
        }
    }
}

struct SampleRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        SampleRecipesView(recipes: .constant([]))
    }
}
