//
//  Ingredient.swift
//  Chaser
//
//  Created by Andrew Whipple on 12/23/24.
//

import Foundation
import SwiftData



@Model
final class Ingredient: Identifiable, CustomStringConvertible {
    var id: UUID
    var name: String
    var unit: Unit
    var amount: Double
    
    
    private var convertedAmount: String {
        var floor = floor(amount)
        var floorString = ""
        if floor > 0 {
            floorString = "\(Int(floor))"
        }
        var remainder = amount - floor
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
    
    init(name: String, unit: Unit, amount: Double) {
        self.id = UUID()
        self.name = name
        self.unit = unit
        self.amount = amount
    }
}

extension Ingredient {
    enum Unit: String, CaseIterable, Codable{
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
    }
    
    static var emptyIngredient: Ingredient {
        Ingredient(name: "", unit: Ingredient.Unit.null, amount: 0)
    }
}
