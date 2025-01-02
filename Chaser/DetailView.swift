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
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(recipe: .constant(Recipe.sampleRecipes[0]))
        }
    }
}
