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
    @State private var isPresentingEditTagAlert = false
    
    @State private var editingIngredient = Ingredient.emptyIngredient
    @State private var editingFreeformText = ""
    @State private var editingTag = ""
    @State private var editingTagIndex: Int?
    
    @State private var photoItem: PhotosPickerItem?
    
    @State private var initialIngredientName = ""
    @State private var initialIngredientAmount = Ingredient.emptyIngredient.amount
    @State private var initialIngredientUnit = Ingredient.emptyIngredient.unit
    
    @State private var parsingProgress = 0
    @State private var isParsing = false
    @State private var animatePulse = false
    @State private var parsingError: ErrorWrapper?
    
    @AppStorage("isAutomaticParsingSectionExpanded") private var isAutomaticParsingSectionExpanded = true
    @AppStorage("showAutomaticParsing") private var showAutomaticParsing = true

    
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
                ForEach(recipe.ingredients ?? []) { ingredient in
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
                        .accessibilityLabel("Edit \(ingredient.name)")
                    }
                }
                .onDelete { indices in
                    recipe.ingredients?.remove(atOffsets: indices)
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
                .accessibilityLabel("Add ingredient")
            }
            Section(header: Text("Instructions")) {
                TextField("Instructions", text: $recipe.instructions, axis: .vertical).lineLimit(10)
            }
            Section(header: Text("Tags")) {
                if !recipe.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(Array(recipe.tags.enumerated()), id: \.offset) { index, tag in
                                Chip(text: tag)
                                    .contextMenu {
                                        Button(action: {
                                            editingTag = tag
                                            editingTagIndex = index
                                            isPresentingEditTagAlert = true
                                        }) {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                        Button(role: .destructive, action: {
                                            recipe.tags.remove(at: index)
                                        }) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .onTapGesture {
                                        editingTag = tag
                                        editingTagIndex = index
                                        isPresentingEditTagAlert = true
                                    }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                Button(action: {
                    editingTag = ""
                    editingTagIndex = nil
                    isPresentingEditTagAlert = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Tag")
                    }
                }
                .accessibilityLabel("Add tag")
            }
            if showAutomaticParsing {
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
                        .accessibilityLabel("Import recipe from text")
                        .accessibilityHint(recipeParser.instance?.loaded == false ? "Apple Intelligence required" : "Parse recipe from pasted text")
                        
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
                        .accessibilityLabel("Import recipe from photo")
                        .accessibilityHint(recipeParser.instance?.loaded == false ? "Apple Intelligence required" : "Parse recipe from photo using text recognition")
                    }
                    .task(id: photoItem) {
                        if let photoData = try? await photoItem?.loadTransferable(type: Data.self) {
                            let photoUIImage = UIImage(data: photoData)!
                            recognizeText(from: photoUIImage) { text in
                                if let text = text {
                                    if !text.isEmpty {
                                        Task {
                                            if let parser = recipeParser.instance {
                                                do {
                                                    isParsing = true
                                                    parsingProgress = 0
                                                    recipe = try await parser.parse(recipeText: text)
                                                    parsingProgress = 3
                                                    isParsing = false
                                                    parsingProgress = 0
                                                } catch {
                                                    isParsing = false
                                                    parsingProgress = 0
                                                    parsingError = ErrorWrapper(
                                                        error: error,
                                                        guidance: "Unable to parse recipe from image. Please try manual entry or check image quality."
                                                    )
                                                }
                                            }
                                            photoItem = nil
                                        }
                                    }
                                } else {
                                    // Text recognition failed
                                    parsingError = ErrorWrapper(
                                        error: NSError(domain: "com.andrewwhipple.Chaser", code: 1, userInfo: [NSLocalizedDescriptionKey: "OCR Failed"]),
                                        guidance: "Unable to recognize text in the image. Please ensure the image is clear and contains visible text."
                                    )
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
        }
        .onAppear {
            Task {
                await recipeParser.checkAndReload()
            }
        }
        .alert(item: $parsingError) { errorWrapper in
            Alert(
                title: Text("Parsing Error"),
                message: Text(errorWrapper.guidance),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(editingTagIndex == nil ? "Add Tag" : "Edit Tag", isPresented: $isPresentingEditTagAlert) {
            TextField("Tag name", text: $editingTag)
            Button("Cancel", role: .cancel) {
                editingTag = ""
                editingTagIndex = nil
            }
            Button(editingTagIndex == nil ? "Add" : "Save") {
                let trimmedTag = editingTag.trimmingCharacters(in: .whitespaces)
                if !trimmedTag.isEmpty {
                    if let index = editingTagIndex {
                        recipe.tags[index] = trimmedTag
                    } else {
                        recipe.tags.append(trimmedTag)
                    }
                }
                editingTag = ""
                editingTagIndex = nil
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
                                // Only append if ingredient name is not empty
                                if !editingIngredient.name.trimmingCharacters(in: .whitespaces).isEmpty {
                                    recipe.ingredients?.append(editingIngredient)
                                }
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
                                        if let parser = recipeParser.instance {
                                            do {
                                                isParsing = true
                                                parsingProgress = 0
                                                recipe = try await parser.parse(recipeText: editingFreeformText)
                                                parsingProgress = 3
                                                isParsing = false
                                                parsingProgress = 0
                                            } catch {
                                                isParsing = false
                                                parsingProgress = 0
                                                parsingError = ErrorWrapper(
                                                    error: error,
                                                    guidance: "Unable to parse recipe from text. Please check the format and try again."
                                                )
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
}

struct DetailEditView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEditView(recipe: .constant(Recipe.sampleRecipes[0]))
    }
}
