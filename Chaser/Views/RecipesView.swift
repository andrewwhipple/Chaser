//
//  RecipesView.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI

struct RecipesView: View {
    @Binding var recipes: [Recipe]
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var isPresentingNewRecipeView = false
    @State private var searchText = ""
    @State private var isImporting = false
    
    let saveAction: () -> Void
    
    var filteredRecipes: [Recipe] {
            if searchText.isEmpty {
                return recipes
            } else {
                return recipes.filter { recipe in
                    recipe.name.localizedCaseInsensitiveContains(searchText) ||
                    recipe.ingredients.contains { ingredient in
                        ingredient.name.localizedCaseInsensitiveContains(searchText)
                    } ||
                    recipe.instructions.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
    
    var body: some View {
        NavigationStack {
            SearchBar(text: $searchText)
            List {
                ForEach(filteredRecipes, id: \.id) { recipe in
                    if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
                            NavigationLink(destination: DetailView(recipe: $recipes[index])) {
                                CardView(recipe: recipe)
                            }
                        }
                }
                .onDelete(perform: deleteRecipe)
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: shareRecipes) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .accessibilityLabel("Share recipes")
                        Button(action: { isImporting = true }) {
                            Image(systemName: "square.and.arrow.down")
                        }
                        .accessibilityLabel("Import recipes")
                        .fileImporter(isPresented: $isImporting, allowedContentTypes: [.json]) { result in
                            handleFileImport(result: result)
                        }
                        Button(action: {
                            isPresentingNewRecipeView = true
                        }) {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel("New recipe")
                    }
                }
                
            }
        }
        .sheet(isPresented: $isPresentingNewRecipeView) {
            NewRecipeView(recipes: $recipes, isPresentingNewRecipeView: $isPresentingNewRecipeView)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .inactive { saveAction() }
        }
    }
    
    private func deleteRecipe(at offsets: IndexSet) {
        recipes.remove(atOffsets: offsets)
    }
    
    private func shareRecipes() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        if let jsonData = try? encoder.encode(recipes),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Recipes-\(UUID()).json")
            try? jsonString.write(to: tempURL, atomically: true, encoding: .utf8)
            
            let activityViewController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = scene.windows.first?.rootViewController {
                rootViewController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    private func handleFileImport(result: Result<URL, Error>) {
        switch result {
        case .success(let fileURL):
            do {
                // Start accessing the file
                let shouldStopAccessing = fileURL.startAccessingSecurityScopedResource()
                
                defer {
                    if shouldStopAccessing {
                        fileURL.stopAccessingSecurityScopedResource()
                    }
                }
                
                // Read the file content
                let data = try Data(contentsOf: fileURL)
                let decodedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
                recipes.append(contentsOf: decodedRecipes)
                
            } catch {
                print("Failed to import recipes: \(error.localizedDescription)")
            }
        case .failure(let error):
            print("File import failed: \(error.localizedDescription)")
        }
    }


}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search Recipes", text: $text)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
        }
    }
}


struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView(recipes: .constant(Recipe.sampleRecipes), saveAction: {})
    }
}
