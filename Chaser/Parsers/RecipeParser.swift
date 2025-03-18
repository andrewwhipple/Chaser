import Foundation
import MLX
import MLXLLM
import MLXLMCommon

class RecipeParser: ObservableObject {
    private var modelContainer: ModelContainer?
    
    @Published var loaded: Bool = false
    
    let maxTokens = 1000
    
    init() async throws {
        loaded = false
        print("Initialzing parser")
        let modelConfiguration = ModelRegistry.llama3_2_3B_4bit
        do {
            self.modelContainer = try await LLMModelFactory.shared.loadContainer(configuration: modelConfiguration)
            loaded = true
            print("Model loaded")
        } catch {
            print("Error loading model")
        }
    }
    
    private func generate(systemPrompt: String, prompt: String) async throws -> String {
        if loaded {
            let result = try await modelContainer!.perform { context in
                let input = try await context.processor.prepare(
                    input: .init(
                        messages: [
                            ["role": "system", "content": systemPrompt],
                            ["role": "user", "content": prompt],
                        ]))
                return try MLXLMCommon.generate(
                    input: input, parameters: GenerateParameters(), context: context
                ) { tokens in
                    //print(context.tokenizer.decode(tokens: tokens))
                    if tokens.count >= maxTokens {
                        return .stop
                    } else {
                        return .more
                    }
                    
                }
            }
            return result.output
        }
        return ""
    }
    
    
    func parseName(recipeText: String) async throws -> String {
        let systemPrompt = """
        You are a simple tool to help parse freeform cocktail recipe text into something more structured.
        
        You will be given text of a recipe. Extract the name of the recipe and return that. Return only the recipe name
        and no other text. Do not return any other commentary other than the recipe name.
        """
        return try await generate(systemPrompt: systemPrompt, prompt: recipeText)
        
    }
    
    func parseInstructions(recipeText: String) async throws -> String {
        let systemPrompt = """
        You are a simple tool to help parse freeform cocktail recipe text into something more structured.
        
        You will be given text of a recipe. Extract the instructions of the recipe and return that. Return only the cocktail instructions
        and no other text.
        
        As an example "01:52
        76),
        OLD FASHIONED
        2 oz BOURBON
        ¼ oz SIMPLE SYRUP (1:1)
        1 DASH ANGOSTURA BITTERS
        1 DASH ORANGE BITTERS
        Stir the bourbon, simple syrup, and bitters in a mixing glass with ice. Strain into a rocks glass with one large ice cube. Garnish with an orange peel.
        EDIT
        OZ
        ML
        QTY: 1" should return "Stir the bourbon, simple syrup, and bitters in a mixing glass with ice. Strain into a rocks glass with one large ice cube. Garnish with an orange peel."
        and "BLINKER
        EDIT
        42 oz GRENADINE
        1 oz GRAPEFRUIT JUICE
        2 oz RYE
        Shake and strain" should return "Shake and strain"
        
        Do not return any commentary or explanation other than what is in the provided text. 
        If you can't find any instructions to parse, return nothing.
        """
        return try await generate(systemPrompt: systemPrompt, prompt: recipeText)
        
    }
    
    func parseIngredients(recipeText: String) async throws -> [Ingredient] {
        let systemPrompt = """
        You are a simple tool to help parse freeform cocktail recipe text into something more structured.
        
        You will be given text of a recipe. Extract the ingredients of the recipe and return them in json of the form
          [
              {
                  "name": string,
                  "unit": string,
                  "amount": float
              }
          ]
        
        Make sure to convert any fractional amounts to a valid float. For example, an ingredient like "1/2 oz of vodka" should be returned as
        {
            "name": "Vodka",
            "unit": "oz",
            "amount": 0.5
        }
        
        Return only this array of ingredients and make sure it is valid JSON with no comments. Do not provide any additional commentary. 
        If you can't parse, return []
        """
        
        var ingredients = [Ingredient]()
        
        let rawIngredientString = try await generate(systemPrompt: systemPrompt, prompt: recipeText)
        let trimmedIngredientString = extractJSONArray(from: rawIngredientString)
        print(trimmedIngredientString)
        let dataString = "\(trimmedIngredientString)".data(using: .utf8)
        
        let decoder = JSONDecoder()
        do {
            let partialIngredients: [PartialIngredient] = try decoder.decode([PartialIngredient].self, from: dataString!)
            print(partialIngredients)
            
            for partialIngredient in partialIngredients {
                let newIngredient = Ingredient(name: partialIngredient.name, unit: partialIngredient.unit, amount: partialIngredient.amount)
                ingredients.append(newIngredient)
            }
        } catch let decodingError as DecodingError {
            print(decodingError)
        }
        
        return ingredients
        
    }
    
    private func extractJSONArray(from text: String) -> String {
        guard let startIndex = text.firstIndex(of: "["),
              let endIndex = text.lastIndex(of: "]") else {
            return "[]"
        }
        
        return String(text[startIndex...endIndex])
    }
}
