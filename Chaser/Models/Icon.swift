//
//  Icon.swift
//  Chaser
//
//  Created by Andrew Whipple on 2/17/26.
//

import SwiftUI

enum Icon: String, CaseIterable, Identifiable {
    case primary    = "AppIcon"
    case margarita = "CoupeWedge" // annoying, to do, actually swap out the icon name
    case collins = "Collins"
    case oldFashioned = "OldFashioned"
    case pintGlass = "PintGlass"
    case shotGlass = "ShotGlass"
    case tropical = "Tropical"
    case wineGlass = "WineGlass"
    
    var id: String { self.rawValue }
    
    var previewImage: String {
        switch self {
        case .primary: "iconPreviewChaser-iOS-Default-1024x1024"
        case .margarita: "iconPreviewCoupeWedge-iOS-Default-1024x1024" // same here
        case .collins: "iconPreviewCollins-iOS-Default-1024x1024"
        case .oldFashioned: "iconPreviewOldFashioned-iOS-Default-1024x1024"
        case .pintGlass: "iconPreviewPintGlass-iOS-Default-1024x1024"
        case .shotGlass: "iconPreviewShotGlass-iOS-Default-1024x1024"
        case .tropical: "iconPreviewTropical-iOS-Default-1024x1024"
        case .wineGlass: "iconPreviewWineGlass-iOS-Default-1024x1024"
        }
    }
    
    var displayText: String {
        switch self {
        case .primary: "Classic"
        case .margarita: "Margarita"
        case .collins: "Collins"
        case .oldFashioned: "Old Fashioned"
        case .pintGlass: "Pint Glass"
        case .shotGlass: "Shot Glass"
        case .tropical: "Tropical"
        case .wineGlass: "Wine Glass"
        }
    }
    
    var targetIconName: String? {
        switch self {
        case .primary: nil
        case _: self.rawValue
        }
    }
    
}
