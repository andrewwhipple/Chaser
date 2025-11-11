import Foundation
import FoundationModels

enum ParserAvailability {
    case available
    case appleIntelligenceNotEnabled
    case deviceNotEligible
    case modelNotReady
    case unavailable
}

class RecipeParser: ObservableObject {
    private var model = SystemLanguageModel.default
    
    @Published var loaded: Bool = false
    @Published var availability: ParserAvailability = .unavailable
    
    init() async throws {
        loaded = false
        switch model.availability {
        case .available:
            loaded = true
            availability = .available
            print("Model loaded")
        case .unavailable(.appleIntelligenceNotEnabled):
            availability = .appleIntelligenceNotEnabled
            print("Turn on apple intelligence")
        case .unavailable(.deviceNotEligible):
            availability = .deviceNotEligible
            print("Device not eligible")
        case .unavailable(.modelNotReady):
            availability = .modelNotReady
            print("Model not ready")
        case .unavailable:
            availability = .unavailable
            print("Model unavailble for unknown reason")
        }
    }
    
    
    func parse(recipetText: String) async throws -> Recipe {
        if loaded {
            let systemPrompt = """
                You are a simple recipe parser who will be given free-form text of a recipe
            and need to parse it out into a structured object, containing the recipe's name, list of ingredients,
            and instructions.
            
            Extract the actual name of the cocktail from the text (e.g., "Old Fashioned", "Margarita", "Mai Tai").
            Do not use placeholder names like "GenerableRecipe" or generic names.
            """
            let session = LanguageModelSession(instructions: systemPrompt)
            
            let response = try await session.respond(to: recipetText, generating: GenerableRecipe.self)
            return response.content.toRecipe()
        }
        return Recipe.emptyRecipe
    }
}
