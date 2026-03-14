//
//  RecipeURLSharing.swift
//  Chaser
//
//  Created on 2/16/26.
//

import Foundation
import SwiftData
import OSLog

class RecipeURLSharing {
    
    private struct ShareableRecipe: Codable {
        let name: String
        let ingredients: [ShareableIngredient]
        let instructions: String
        let tags: [String]
        
        struct ShareableIngredient: Codable {
            let name: String
            let unit: String
            let amount: Double
        }
    }
    
    static func createShareURL(from recipe: Recipe) -> URL? {
        do {
            let shareableIngredients = (recipe.ingredients ?? []).map { ingredient in
                ShareableRecipe.ShareableIngredient(
                    name: sanitize(ingredient.name),
                    unit: ingredient.unit.rawValue,
                    amount: ingredient.amount
                )
            }
            
            let shareableRecipe = ShareableRecipe(
                name: sanitize(recipe.name),
                ingredients: shareableIngredients,
                instructions: sanitize(recipe.instructions),
                tags: recipe.tags.map { sanitize($0) }
            )
            
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(shareableRecipe)
            
            let base64String = jsonData.base64EncodedString()
            
            guard let urlEncodedString = base64String.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                Logger.storage.error("Failed to URL encode recipe data")
                return nil
            }
            
            let urlString = "chasercocktails://recipe?data=\(urlEncodedString)"
            return URL(string: urlString)
            
        } catch {
            Logger.storage.error("Failed to create share URL: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func decodeRecipe(from url: URL) throws -> Recipe {
        
        guard url.scheme == "chasercocktails" else {
            throw RecipeSharingError.invalidScheme
        }
        
        guard url.host == "recipe" || url.path == "/recipe" else {
            throw RecipeSharingError.invalidURL
        }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let dataItem = queryItems.first(where: { $0.name == "data" }),
              let encodedData = dataItem.value else {
            throw RecipeSharingError.missingData
        }
        
        guard let base64String = encodedData.removingPercentEncoding else {
            throw RecipeSharingError.invalidEncoding
        }
        
        guard let jsonData = Data(base64Encoded: base64String) else {
            throw RecipeSharingError.invalidBase64
        }
        
        let maxDataSize = 1_000_000 // 1MB limit
        guard jsonData.count <= maxDataSize else {
            throw RecipeSharingError.dataTooLarge
        }
        
        let decoder = JSONDecoder()
        let shareableRecipe = try decoder.decode(ShareableRecipe.self, from: jsonData)
        
        try validate(shareableRecipe)
        
        let ingredients = shareableRecipe.ingredients.map { shareableIngredient in
            Ingredient(
                name: sanitize(shareableIngredient.name),
                unit: Ingredient.Unit(rawValue: shareableIngredient.unit),
                amount: shareableIngredient.amount
            )
        }
        
        let recipe = Recipe(
            name: sanitize(shareableRecipe.name),
            ingredients: ingredients,
            instructions: sanitize(shareableRecipe.instructions),
            tags: shareableRecipe.tags.map { sanitize($0) }
        )
        
        Logger.storage.info("Successfully decoded recipe from URL: \(recipe.name)")
        return recipe
    }
    
    private static func sanitize(_ input: String) -> String {

        var sanitized = input.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove null bytes and other control characters (except newlines and tabs which are OK in instructions)
        sanitized = sanitized.filter { char in
            let scalar = char.unicodeScalars.first!
            // Allow newlines, tabs, and normal printable characters
            // Control characters are in the range U+0000 to U+001F and U+007F to U+009F
            let value = scalar.value
            return scalar == "\n" || scalar == "\t" || 
                   (value >= 0x0020 && value < 0x007F) || // ASCII printable
                   (value >= 0x00A0 && value != 0xFFFE && value != 0xFFFF) // Extended Unicode (excluding non-characters)
        }
        
        // Limit length to prevent abuse
        let maxLength = 10_000
        if sanitized.count > maxLength {
            sanitized = String(sanitized.prefix(maxLength))
        }
        
        return sanitized
    }
    

    private static func validate(_ shareableRecipe: ShareableRecipe) throws {
        // Validate name
        guard !shareableRecipe.name.isEmpty else {
            throw RecipeSharingError.invalidData("Recipe name cannot be empty")
        }
        
        guard shareableRecipe.name.count <= 500 else {
            throw RecipeSharingError.invalidData("Recipe name is too long")
        }
        
        // Validate ingredients
        guard shareableRecipe.ingredients.count <= 100 else {
            throw RecipeSharingError.invalidData("Too many ingredients")
        }
        
        for ingredient in shareableRecipe.ingredients {
            guard !ingredient.name.isEmpty else {
                throw RecipeSharingError.invalidData("Ingredient name cannot be empty")
            }
            
            guard ingredient.amount >= 0 && ingredient.amount.isFinite else {
                throw RecipeSharingError.invalidData("Invalid ingredient amount")
            }
        }
        
        // Validate instructions
        guard !shareableRecipe.instructions.isEmpty else {
            throw RecipeSharingError.invalidData("Instructions cannot be empty")
        }
        
        guard shareableRecipe.instructions.count <= 10_000 else {
            throw RecipeSharingError.invalidData("Instructions are too long")
        }
        
        // Validate tags
        guard shareableRecipe.tags.count <= 50 else {
            throw RecipeSharingError.invalidData("Too many tags")
        }
    }
    
    
    enum RecipeSharingError: LocalizedError {
        case invalidScheme
        case invalidURL
        case missingData
        case invalidEncoding
        case invalidBase64
        case dataTooLarge
        case invalidData(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidScheme:
                return "Invalid URL scheme. Expected 'chasercocktails://'."
            case .invalidURL:
                return "Invalid recipe URL format."
            case .missingData:
                return "No recipe data found in URL."
            case .invalidEncoding:
                return "Failed to decode URL-encoded data."
            case .invalidBase64:
                return "Invalid base64-encoded data."
            case .dataTooLarge:
                return "Recipe data is too large to import."
            case .invalidData(let message):
                return "Invalid recipe data: \(message)"
            }
        }
    }
}
