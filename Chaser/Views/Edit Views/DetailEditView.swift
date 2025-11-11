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
    
    @AppStorage("isAutomaticParsingSectionExpanded") private var isAutomaticParsingSectionExpanded = true

    
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
            Section {
                DisclosureGroup("Automatic parsing", isExpanded: $isAutomaticParsingSectionExpanded) {
                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: {
                            isPresentingFreeformInputEditView = true
                        }) {
                            HStack {
                                Image(systemName: "text.alignleft")
                                Text("Import from text")
                                Spacer()
                            }
                            .padding()
                        }
                        .disabled(recipeParser.instance?.loaded == false)
                        .buttonStyle(.bordered)
                        
                        PhotosPicker(selection: $photoItem) {
                            HStack {
                                Image(systemName: "photo")
                                Text("Import from image")
                                Spacer()
                            }
                            .padding()
                        }
                        .disabled(recipeParser.instance?.loaded == false)
                        .buttonStyle(.bordered)
                    }
                    .task(id: photoItem) {
                        if let photoData = try? await photoItem?.loadTransferable(type: Data.self) {
                            let photoUIImage = UIImage(data: photoData)!
                            recognizeText(from: photoUIImage) { text in
                                if let text = text {
                                    if !text.isEmpty {
                                        Task {
                                            if let parser = recipeParser.instance {
                                                isParsing = true
                                                parsingProgress = 0
                                                recipe = try await parser.parse(recipetText: text)
                                                parsingProgress = 3
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
                    if recipeParser.instance?.loaded == false {
                        switch recipeParser.instance?.availability {
                        case .appleIntelligenceNotEnabled:
                            Text("To use automatic parsing, please enable Apple Intelligence in Settings. It may take up to a few minutes for parsing to be available after enabling.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        case .deviceNotEligible:
                            Text("Apple Intelligence is not available on this device.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        case .modelNotReady:
                            Text("Automatic parsing not ready yet; please wait or try again.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        case .unavailable:
                            Text("Automatic parsing is unavailable due to an unknown error.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await recipeParser.checkAndReload()
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
                    .navigationTitle("Import from text")
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
                                            recipe = try await parser.parse(recipetText: editingFreeformText)
                                            parsingProgress = 3
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
