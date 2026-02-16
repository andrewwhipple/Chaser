//
//  ContentView.swift
//  Chaser
//
//  Created by GitHub Copilot on 2/16/26.
//

import SwiftUI
import SwiftData
import CloudKit
import OSLog

/// Bridge view that connects SwiftData (with CloudKit) to the existing RecipesView
struct ContentView: View {
    // SwiftData automatically loads and syncs with CloudKit!
    @Query(sort: [SortDescriptor(\Recipe.updatedAt, order: .reverse)]) private var recipes: [Recipe]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        RecipesView(
            recipes: Binding(
                get: { recipes },
                set: { (_: [Recipe]) in /* SwiftData auto-saves */ }
            )
        )
        .environment(\.modelContext, modelContext)
    }
}
