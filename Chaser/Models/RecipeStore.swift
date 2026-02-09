//
//  RecipeStore.swift
//  Chaser
//
//  Created by Andrew Whipple on 1/2/25.
//

import SwiftUI
import OSLog

@MainActor
class RecipeStore: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent( "recipes.data")
    }
    
    func load() async throws {
        let task = Task<[Recipe], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                Logger.storage.info("No existing recipe data found, starting with empty collection")
                return []
            }
            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
            Logger.storage.info("Loaded \(recipes.count) recipe(s) from storage")
            return recipes
        }
        let recipes = try await task.value
        self.recipes = recipes
    }
    
    func save(recipes: [Recipe]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(recipes)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
            Logger.storage.info("Saved \(recipes.count) recipe(s) to storage")
        }
        
        _ = try await task.value
    }
}
