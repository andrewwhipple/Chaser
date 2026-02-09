//
//  ChaserApp.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI
import SwiftData
import OSLog

@main
struct ChaserApp: App {
    @StateObject private var store = RecipeStore()
    @State private var errorWrapper: ErrorWrapper?
    @StateObject var recipeParser: RecipeParserWrapper
    
    @State private var importedFileURL: URL?
    @Environment(\.scenePhase) private var scenePhase
    
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
            // If persistent storage fails, fall back to in-memory storage
            Logger.storage.error("Failed to create persistent ModelContainer: \(error.localizedDescription). Falling back to in-memory storage.")
            let inMemoryConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            do {
                return try ModelContainer(for: schema, configurations: [inMemoryConfiguration])
            } catch {
                // This should never happen, but if it does, we have a critical issue
                Logger.storage.fault("Could not create ModelContainer with either persistent or in-memory storage: \(error.localizedDescription)")
                fatalError("Could not create ModelContainer with either persistent or in-memory storage: \(error)")
            }
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
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active {
                    Task {
                        await recipeParser.checkAndReload()
                    }
                }
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
            Logger.storage.info("Successfully imported \(decodedRecipes.count) recipe(s)")
        } catch {
            Logger.storage.error("Failed to import recipes: \(error.localizedDescription)")
            errorWrapper = ErrorWrapper(error: error, guidance: "Unable to import recipes. Please ensure the file is a valid Chaser recipe export.")
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
            // Parser initialization failed - UI will display appropriate message based on availability
            self.instance = nil
        }
    }
    
    @MainActor
    func checkAndReload() async {
        if instance?.loaded == true {
            return
        }
        
        if instance?.availability == .deviceNotEligible {
            return
        }
        
        // Attempt to reload for any other reason (modelNotReady, appleIntelligenceNotEnabled, unavailable, or nil)
        await initializeParser()
    }
}
