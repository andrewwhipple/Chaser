//
//  Ingredient.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import Foundation
import FoundationModels
import SwiftData



@Model
final class Ingredient: Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, unit, amount
    }
    
    var id: UUID
    var name: String
    var unit: Unit
    var amount: Double

    init(name: String, unit: Unit, amount: Double) {
        self.id = UUID()
        self.name = name
        self.unit = unit
        self.amount = amount
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let unit = try container.decode(Unit.self, forKey: .unit)
        let amount = try container.decode(Double.self, forKey: .amount)
        self.init(name: name, unit: unit, amount: amount)
        self.id = id
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(unit, forKey: .unit)
        try container.encode(amount, forKey: .amount)
    }
}

extension Ingredient:  CustomStringConvertible{
    private var convertedAmount: String {
        let floor = floor(amount)
        var floorString = ""
        if floor > 0 {
            floorString = "\(Int(floor))"
        }
        let remainder = amount - floor
        var remainderString = ""
        switch remainder {
        case 0:
            remainderString = ""
        case 0.125:
            remainderString = "⅛"
        case 0.25:
            remainderString = "¼"
        case 0.375:
            remainderString = "⅜"
        case 0.5:
            remainderString = "½"
        case 0.625:
            remainderString = "⅝"
        case 0.75:
            remainderString = "¾"
        case 0.875:
            remainderString = "⅞"
        default:
            remainderString = "\(remainder)"
        }
        
        return "\(floorString)\(remainderString)"
    }
    
    var description: String {
        var printedAmount = "\(convertedAmount) "
        if amount == 0 {
            printedAmount = ""
        }
        var printedUnit = "\(unit) "
        if unit == Ingredient.Unit.null {
            printedUnit = ""
        }
        
        return "\(printedAmount)\(printedUnit)\(name)"
    }
}


extension Ingredient {
    enum Unit: String, CaseIterable, Codable {
        case ounce = "ounce"
        case milliliter = "milliliter"
        case dash = "dash"
        case teaspoon = "teaspoon"
        case tablespoon = "tablespoon"
        case cup = "cup"
        case pint = "pint"
        case liter = "liter"
        case drop = "drop"
        case pinch = "pinch"
        case null = ""
        
        init(rawValue: String) {
            switch rawValue.lowercased() {
            case "oz", "ounce", "ounces", "fluid ounce", "fluid oz", "fluid ounces", "oz.":
                self = .ounce
            case "ml", "milliliter", "milliters":
                self = .milliliter
            case "tbsp", "tablespoon", "tablespoons":
                self = .tablespoon
            case "tsp", "teaspoon", "teaspoons":
                self = .teaspoon
            case "l", "liter", "liters":
                self = .liter
            case "dash", "dashes":
                self = .dash
            case "pinch", "pinches":
                self = .pinch
            case "drop", "drops":
                self = .drop
            case "cup", "cups":
                self = .cup
            case "pint", "pints":
                self = .pint
            default:
                self = .null
            }
        }
    }
    
    static var emptyIngredient: Ingredient {
        Ingredient(name: "", unit: Ingredient.Unit.null, amount: 0)
    }
}

import Foundation

struct PartialIngredient: Codable {
    enum CodingKeys: String, CodingKey {
        case name, unit, amount
    }
    
    var name: String
    var unit: Ingredient.Unit
    var amount: Double
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        unit = try container.decode(Ingredient.Unit.self, forKey: .unit)
        
        if let doubleValue = try? container.decode(Double.self, forKey: .amount) {
            amount = doubleValue
        } else if let stringValue = try? container.decode(String.self, forKey: .amount),
                  let doubleFromString = Double(stringValue) {
            amount = doubleFromString
        } else {
            throw DecodingError.dataCorruptedError(forKey: .amount, in: container, debugDescription: "Amount is neither a Double nor a valid String representation of a Double")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(unit, forKey: .unit)
        try container.encode(amount, forKey: .amount)
    }
}

@Generable()
struct GenerableIngredient {
    @Guide(description: "Name of the ingredient")
    var name: String
    @Guide(description: "The unit for the ingredient (ex: ounce, ml, dash, barspoon, etc)")
    var unit: String
    var amount: Double
}
