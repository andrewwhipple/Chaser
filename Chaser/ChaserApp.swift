//
//  ChaserApp.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import SwiftUI
import SwiftData
import OSLog
import CloudKit

@main
struct ChaserApp: App {
    @StateObject private var store = RecipeStore()
    @State private var errorWrapper: ErrorWrapper?
    @StateObject var recipeParser: RecipeParserWrapper
    
    @State private var importedFileURL: URL?
    @State private var pendingRecipeImport: Recipe?
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        _recipeParser = StateObject(wrappedValue: RecipeParserWrapper())
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recipe.self,
        ])
        // Use SwiftData's built-in CloudKit integration
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .private("iCloud.com.andrewwhipple.Chaser")
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // If persistent storage fails, fall back to in-memory storage
            Logger.storage.error("Failed to create persistent ModelContainer: \(error.localizedDescription). Falling back to in-memory storage.")
            let inMemoryConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true,
                cloudKitDatabase: .none
            )
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
            ContentView(pendingRecipeImport: $pendingRecipeImport)
                .environmentObject(store)
            .sheet(item: $errorWrapper) {
                // No need to load sample recipes - SwiftData handles persistence
            } content: { wrapper in
                ErrorView(errorWrapper: wrapper)
            }.onOpenURL { url in
                handleIncomingURL(url: url)
            }
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                handleCloudKitShare(userActivity: userActivity)
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
    
    private func handleIncomingURL(url: URL) {
        // Handle chasercocktails:// recipe sharing URL
        if url.scheme == "chasercocktails" {
            do {
                let recipe = try RecipeURLSharing.decodeRecipe(from: url)
                pendingRecipeImport = recipe
                Logger.storage.info("Successfully decoded recipe from URL: \(recipe.name)")
            } catch {
                Logger.storage.error("Failed to decode recipe from URL: \(error.localizedDescription)")
                errorWrapper = ErrorWrapper(
                    error: error,
                    guidance: error.localizedDescription
                )
            }
            return
        }
        
        // Check if it's a CloudKit share URL
        if url.scheme == "https" && url.host?.contains("icloud") == true {
            // This will be handled by handleCloudKitShare
            return
        }
        
        // Otherwise, handle as file import
        handleIncomingFile(url: url)
    }
    
    private func handleCloudKitShare(userActivity: NSUserActivity) {
        // CloudKit share metadata is passed through userInfo
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let incomingURL = userActivity.webpageURL,
              let components = URLComponents(url: incomingURL, resolvingAgainstBaseURL: false) else {
            return
        }
        
        // For CloudKit shares, we need to use the CKContainer.accept method
        // The metadata needs to be fetched from the URL
        Task {
            do {
                let container = CKContainer(identifier: "iCloud.com.andrewwhipple.Chaser")
                let metadata = try await container.shareMetadata(for: incomingURL)
                try await store.acceptShare(metadata: metadata)
                Logger.storage.info("Successfully accepted CloudKit share")
            } catch {
                Logger.storage.error("Failed to accept share: \(error.localizedDescription)")
                errorWrapper = ErrorWrapper(
                    error: error,
                    guidance: "Unable to accept the shared recipes. Please try again."
                )
            }
        }
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
