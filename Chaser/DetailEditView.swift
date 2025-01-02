//
//  DetailEditView.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI

struct DetailEditView: View {
    @Binding var recipe: Recipe
    
    @State private var isPresentingEditIngredientsView = false
    
    @State private var editingIngredient = Ingredient.emptyIngredient
    
    @State private var initialIngredientName = ""
    @State private var initialIngredientAmount = Ingredient.emptyIngredient.amount
    @State private var initialIngredientUnit = Ingredient.emptyIngredient.unit


    
    private func editIngredientsViewTitle(title: String) -> String {
        if title.isEmpty{
            return "New ingredient"
        } else {
            return title
        }
    }
    
    var body: some View {
        Form{
            Section(header: Text("Recipe")) {
                TextField("Name", text: $recipe.name )
            }
            Section(header: Text("Ingredients")) {
                ForEach(recipe.ingredients) { ingredient in
                    HStack {
                        Text(ingredient.description)
                        Button(action: {
                            isPresentingEditIngredientsView = true
                            editingIngredient = ingredient
                            initialIngredientName = ingredient.name
                            initialIngredientAmount = ingredient.amount
                            initialIngredientUnit = ingredient.unit
                        }) {
                            Image(systemName: "pencil")
                        }
                    }
                }
                .onDelete { indices in
                    recipe.ingredients.remove(atOffsets: indices)
                }
                Button(action: {
                    initialIngredientName = Ingredient.emptyIngredient.name
                    initialIngredientAmount = Ingredient.emptyIngredient.amount
                    initialIngredientUnit = Ingredient.emptyIngredient.unit
                    editingIngredient = Ingredient.emptyIngredient
                    isPresentingEditIngredientsView = true
                }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
            Section(header: Text("Instructions")) {
                TextField("Instructions", text: $recipe.instructions)
            }
        }
        .sheet(isPresented: $isPresentingEditIngredientsView) {
            NavigationStack {
                IngredientEditView(ingredient: $editingIngredient)
                    .navigationTitle(editIngredientsViewTitle(title: editingIngredient.name))
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isPresentingEditIngredientsView = false
                                editingIngredient.name = initialIngredientName
                                editingIngredient.amount = initialIngredientAmount
                                editingIngredient.unit = initialIngredientUnit
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isPresentingEditIngredientsView = false
                                recipe.ingredients.append(editingIngredient)
                            }
                        }
                    }
            }
        }
    }
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(recipe: .constant(Recipe.sampleRecipes[0]))
    }
}
