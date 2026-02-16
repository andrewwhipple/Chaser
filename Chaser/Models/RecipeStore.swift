//
//  RecipeStore.swift
//  Chaser
//
//  Created by Andrew Whipple on 1/2/25.
//

import SwiftUI
import OSLog
import CloudKit

@MainActor
class RecipeStore: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    // Note: With SwiftData's CloudKit integration, syncing happens automatically!
    // This class now mainly handles JSON export/import for backward compatibility
    
    // MARK: - File-based Methods (for backward compatibility and export)
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("recipes.data")
    }
    
    func load() async throws {
        // With SwiftData + CloudKit, we don't need to manually load
        // The views use @Query which automatically loads from SwiftData
        // This method is kept for backward compatibility
        Logger.storage.info("RecipeStore.load() called - with SwiftData+CloudKit, use @Query in views instead")
    }
    
    func save(recipes: [Recipe]) async throws {
        // With SwiftData + CloudKit, we don't need to manually save
        // Changes are automatically saved and synced by SwiftData
        // This method is kept for backward compatibility
        Logger.storage.info("RecipeStore.save() called - with SwiftData+CloudKit, changes auto-save")
    }
    
    // MARK: - JSON Export/Import (for sharing and backup)
    
    func exportToJSON() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(recipes)
    }
    
    func importFromJSON(_ data: Data) throws -> [Recipe] {
        return try JSONDecoder().decode([Recipe].self, from: data)
    }
    
    // MARK: - CloudKit Sharing (using SwiftData's built-in support)
    
    func shareRecipe(_ recipe: Recipe) async throws -> CKShare {
        // With SwiftData + CloudKit, sharing is handled through the ModelContext
        // This needs to be implemented using SwiftData's sharing APIs
        throw NSError(domain: "RecipeStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Sharing not yet implemented with SwiftData"])
    }
    
    func shareAllRecipes() async throws -> CKShare {
        throw NSError(domain: "RecipeStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Sharing not yet implemented with SwiftData"])
    }
    
    func acceptShare(metadata: CKShare.Metadata) async throws {
        throw NSError(domain: "RecipeStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Sharing not yet implemented with SwiftData"])
    }
}
