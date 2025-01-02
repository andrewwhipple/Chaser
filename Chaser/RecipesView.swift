//
//  RecipesView.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI

struct RecipesView: View {
    @Binding var recipes: [Recipe]
    
    @State private var isPresentingNewRecipeView = false
    
    var body: some View {
        NavigationStack {
            List($recipes) { $recipe in
                NavigationLink(destination: DetailView(recipe: $recipe)) {
                    CardView(recipe: recipe)
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                Button(action: {
                    isPresentingNewRecipeView = true
                }) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New recipe")
                
            }
        }
        .sheet(isPresented: $isPresentingNewRecipeView) {
            NewRecipeView(recipes: $recipes, isPresentingNewRecipeView: $isPresentingNewRecipeView)
        }
    }
}


struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView(recipes: .constant(Recipe.sampleRecipes))
    }
}
