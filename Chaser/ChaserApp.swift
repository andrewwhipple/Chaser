//
//  ChaserApp.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI
import SwiftData

@main
struct ChaserApp: App {
    @StateObject private var store = RecipeStore()
    @State private var errorWrapper: ErrorWrapper?
    @StateObject var recipeParser: RecipeParserWrapper
    
    @State private var importedFileURL: URL?
    
    init() {
        _recipeParser = StateObject(wrappedValue: RecipeParserWrapper())
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recipe.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RecipesView(recipes: $store.recipes) {
                Task {
                    do {
                        try await store.save(recipes: store.recipes)
                    } catch {
                        errorWrapper = ErrorWrapper(error: error, guidance: "Try again later")
                    }
                }
            }
            .task {
                do {
                    try await store.load()
                } catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "App will load sample data and continue")
                }
            }
            .sheet(item: $errorWrapper) {
                store.recipes = Recipe.sampleRecipes
            } content: { wrapper in
                ErrorView(errorWrapper: wrapper)
            }.onOpenURL { url in
                handleIncomingFile(url: url)
            }
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(recipeParser)
    }
    
    private func handleIncomingFile(url: URL) {
        do {
            let shouldStopAccessing = url.startAccessingSecurityScopedResource()
            
            defer {
                if shouldStopAccessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }

            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
            if FileManager.default.fileExists(atPath: tempURL.path) {
                try FileManager.default.removeItem(at: tempURL)
            }
            try FileManager.default.copyItem(at: url, to: tempURL)

            let data = try Data(contentsOf: tempURL)
            let decodedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
            store.recipes.append(contentsOf: decodedRecipes)

            print("Successfully imported recipes!")
        } catch {
            print("Failed to import recipes: \(error.localizedDescription)")
        }
    }
}

final class RecipeParserWrapper: ObservableObject {
    @Published var instance: RecipeParser?

    init() {
        Task {
            await initializeParser()
        }
    }

    @MainActor
    private func initializeParser() async {
        do {
            let parser = try await RecipeParser()
            self.instance = parser
        } catch {
            print("Failed to initialize RecipeParser: \(error)")
        }
    }
}
