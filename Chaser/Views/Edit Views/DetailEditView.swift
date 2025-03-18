//
//  DetailEditView.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import PhotosUI
import SwiftUI

struct DetailEditView: View {
    @Binding var recipe: Recipe
    @EnvironmentObject var recipeParser: RecipeParserWrapper
    
    @State private var isPresentingEditIngredientsView = false
    @State private var isPresentingFreeformInputEditView = false
    
    @State private var editingIngredient = Ingredient.emptyIngredient
    @State private var editingFreeformText = ""
    
    @State private var photoItem: PhotosPickerItem?
    
    @State private var initialIngredientName = ""
    @State private var initialIngredientAmount = Ingredient.emptyIngredient.amount
    @State private var initialIngredientUnit = Ingredient.emptyIngredient.unit
    
    @State private var parsingProgress = 0
    @State private var isParsing = false
    @State private var animatePulse = false

    
    private func editIngredientsViewTitle(title: String) -> String {
        if title.isEmpty{
            return "New ingredient"
        } else {
            return title
        }
    }
    
    var body: some View {
        Form {
            if isParsing {
                Section(header: Text("Parsing Progress")) {
                    ProgressView(value: Double(parsingProgress), total: 3)
                        .progressViewStyle(LinearProgressViewStyle())
                        .opacity(animatePulse ? 0.7 : 1.0)      // Slight opacity shift
                        .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: animatePulse)
                        .onAppear {
                            animatePulse = true
                        }
                }
            }
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
                TextField("Instructions", text: $recipe.instructions, axis: .vertical).lineLimit(10)
            }
            Section(header: Text("Automatic parsing")) {
                HStack {
                    //Button(action: {
                    //    isPresentingFreeformInputEditView = true
                    //}) {
                    //    Text("Parse from text")
                    //}
                    //Spacer()
                    PhotosPicker(selection: $photoItem) {
                        Text("Import from image")
                    }.disabled(recipeParser.instance?.loaded == false)
                }.task(id: photoItem) {
                    if let photoData = try? await photoItem?.loadTransferable(type: Data.self) {
                        let photoUIImage = UIImage(data: photoData)!
                        recognizeText(from: photoUIImage) { text in
                            if let text = text {
                                if !text.isEmpty {
                                    Task {
                                        if let parser = recipeParser.instance {
                                            isParsing = true
                                            parsingProgress = 0
                                            recipe.name = try await parser.parseName(recipeText: text)
                                            parsingProgress += 1
                                            recipe.ingredients = try await parser.parseIngredients(recipeText: text)
                                            parsingProgress += 1
                                            recipe.instructions = try await parser.parseInstructions(recipeText: text)
                                            parsingProgress += 1
                                            isParsing = false
                                            
                                            parsingProgress = 0
                                        }
                                        photoItem = nil
                                    }
                                }
                            } else {
                                print("Failed to recognize text.")
                                photoItem = nil
                            }
                        }
                    }
                }
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
        .sheet(isPresented: $isPresentingFreeformInputEditView) {
            NavigationStack {
                FreeformInputEditView(inputText: $editingFreeformText)
                    .navigationTitle("Freeform text input")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button("Cancel") {
                                isPresentingFreeformInputEditView = false
                                editingFreeformText = ""
                            }
                            Button("Done") {
                                isPresentingFreeformInputEditView = false
                                if !editingFreeformText.isEmpty {
                                    Task {
                                        print("Hi")
                                        if let parser = recipeParser.instance {
                                            isParsing = true
                                            parsingProgress = 0
                                            recipe.name = try await parser.parseName(recipeText: editingFreeformText)
                                            parsingProgress += 1
                                            recipe.ingredients = try await parser.parseIngredients(recipeText: editingFreeformText)
                                            parsingProgress += 1
                                            recipe.instructions = try await parser.parseInstructions(recipeText: editingFreeformText)
                                            parsingProgress += 1
                                            isParsing = false
                                            
                                            parsingProgress = 0
                                        }
                                    }
                                }
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
