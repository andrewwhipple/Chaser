//
//  RecipeStore.swift
//  Chaser
//
//  Created by Andrew Whipple on 1/2/25.
//

import SwiftUI

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
                return []
            }
            let recipes = try JSONDecoder().decode([Recipe].self, from: data)
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
        }
        
        _ = try await task.value
    }
}
