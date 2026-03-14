//
//  SettingsView.swift
//  Chaser
//
//  Created by GitHub Copilot on 2/16/26.
//

import SwiftUI
import SwiftData
import StoreKit

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var recipes: [Recipe]
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    @AppStorage("showAutomaticParsing") private var showAutomaticParsing = true
    @AppStorage("jsonImportExportEnabled") private var jsonImportExportEnabled = false
    @AppStorage("showAutomaticIngredientTags") private var showAutomaticIngredientTags = true
    @State private var showingDeleteConfirmation = false
    @State private var deleteConfirmationText = ""
    @State private var currentIconName: String?
    @State private var isPurchasing = false
    @State private var isTipping = false
    @State private var showTipThanks = false
    @State private var isRestoring = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Recipes Library")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Show automatic ingredient tags", isOn: $showAutomaticIngredientTags)
                        Text("Automatically show tags for each recipe in the Recipes library based on whether the recipe contains common cocktail ingredients.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Section(header: Text("Recipe Editor")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Show automatic parsing", isOn: $showAutomaticParsing)
                        Text("Show automatic parsing from text and images using Apple Intelligence on the Recipe editor. If you're not a fan of automatic parsing, or if your device doesn't support it, you can disable the feature and it will no longer show up.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Section(header: Text("Import/Export")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Import/Export via JSON files", isOn: $jsonImportExportEnabled)
                        Text("If you want more control over your recipe library, you can enable the ability to import and export your recipes as JSON files to back up or share your library.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if purchaseManager.customIconProduct != nil {
                    Section(header: Text("App Icon")) {
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(spacing: 20) {
                                Button(action: {
                                    changeAppIcon(to: nil)
                                }) {
                                    VStack(spacing: 8) {
                                        IconSelector(icon: Icon.primary, currentIconName: currentIconName)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                Spacer()
                                Button(action: {
                                    changeAppIcon(to: "CoupeWedge")
                                }) {
                                    VStack(spacing: 8) {
                                        IconSelector(icon: Icon.margarita, currentIconName: currentIconName, locked: !purchaseManager.hasUnlockedCustomIcons)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!purchaseManager.hasUnlockedCustomIcons)
                                Spacer()
                                Button(action: {
                                    changeAppIcon(to: "OldFashioned")
                                }) {
                                    VStack(spacing: 8) {
                                        IconSelector(icon: Icon.oldFashioned, currentIconName: currentIconName, locked: !purchaseManager.hasUnlockedCustomIcons)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!purchaseManager.hasUnlockedCustomIcons)
                                Spacer()
                                Button(action: {
                                    changeAppIcon(to: "Tropical")
                                }) {
                                    VStack(spacing: 8) {
                                        IconSelector(icon: Icon.tropical, currentIconName: currentIconName, locked: !purchaseManager.hasUnlockedCustomIcons)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!purchaseManager.hasUnlockedCustomIcons)
                                Spacer()
                                Button(action: {
                                    changeAppIcon(to: "Collins")
                                }) {
                                    VStack(spacing: 8) {
                                        IconSelector(icon: Icon.collins, currentIconName: currentIconName, locked: !purchaseManager.hasUnlockedCustomIcons)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!purchaseManager.hasUnlockedCustomIcons)
                                Spacer()
                                Button(action: {
                                    changeAppIcon(to: "PintGlass")
                                }) {
                                    VStack(spacing: 8) {
                                        IconSelector(icon: Icon.pintGlass, currentIconName: currentIconName, locked: !purchaseManager.hasUnlockedCustomIcons)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!purchaseManager.hasUnlockedCustomIcons)
                                Spacer()
                                Button(action: {
                                    changeAppIcon(to: "WineGlass")
                                }) {
                                    VStack(spacing: 8) {
                                        IconSelector(icon: Icon.wineGlass, currentIconName: currentIconName, locked: !purchaseManager.hasUnlockedCustomIcons)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!purchaseManager.hasUnlockedCustomIcons)
                                Spacer()
                                Button(action: {
                                    changeAppIcon(to: "ShotGlass")
                                }) {
                                    VStack(spacing: 8) {
                                        IconSelector(icon: Icon.shotGlass, currentIconName: currentIconName, locked: !purchaseManager.hasUnlockedCustomIcons)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(!purchaseManager.hasUnlockedCustomIcons)
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                        
                        if !purchaseManager.hasUnlockedCustomIcons {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Change your app icon to match your favorite drink or cocktail")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Button(action: {
                                    guard let product = purchaseManager.customIconProduct else { return }
                                    isPurchasing = true
                                    Task {
                                        defer { isPurchasing = false }
                                        try? await purchaseManager.purchase(product)
                                    }
                                }) {
                                    HStack {
                                        Spacer()
                                        if isPurchasing {
                                            ProgressView()
                                        } else {
                                            let priceLabel = purchaseManager.customIconProduct.map { "Unlock Custom Icons — \($0.displayPrice)" } ?? "Unlock Custom Icons"
                                            Text(priceLabel)
                                                .bold()
                                        }
                                        Spacer()
                                    }
                                }
                                .disabled(isPurchasing || purchaseManager.customIconProduct == nil)
                            }
                        }
                    }
                }
                
                if purchaseManager.oneDollarTipProduct != nil {
                    Section(header: Text("Support")) {
                        if showTipThanks {
                            HStack {
                                Spacer()
                                VStack(spacing: 4) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.pink)
                                        .font(.title2)
                                    Text("Thanks for the support!")
                                        .bold()
                                    Text("It means a lot. Cheers! 🍸")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 6)
                                Spacer()
                            }
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Enjoying Chaser? Want to help keep it going? Feel free to buy us a drink!")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Button(action: {
                                    guard let product = purchaseManager.oneDollarTipProduct else { return }
                                    isTipping = true
                                    Task {
                                        defer { isTipping = false }
                                        try? await purchaseManager.purchase(product)
                                        showTipThanks = true
                                    }
                                }) {
                                    HStack {
                                        Spacer()
                                        if isTipping {
                                            ProgressView()
                                        } else {
                                            let priceLabel = purchaseManager.oneDollarTipProduct.map { "Tip the Developer — \($0.displayPrice)" } ?? "Tip the Developer"
                                            Text(priceLabel)
                                                .bold()
                                        }
                                        Spacer()
                                    }
                                }
                                .disabled(isTipping || purchaseManager.oneDollarTipProduct == nil)
                            }
                        }
                    }
                }

                Section {
                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Delete all recipes")
                                .foregroundColor(.red)
                                .bold()
                            Spacer()
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        isRestoring = true
                        Task {
                            defer { isRestoring = false }
                            try? await AppStore.sync()
                        }
                    }) {
                        HStack {
                            Spacer()
                            if isRestoring {
                                ProgressView()
                            } else {
                                Text("Restore Purchases")
                            }
                            Spacer()
                        }
                    }
                    .disabled(isRestoring)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Are you sure?", isPresented: $showingDeleteConfirmation) {
                TextField("Type delete", text: $deleteConfirmationText)
                
                Button("Dismiss", role: .cancel) {
                    deleteConfirmationText = ""
                }
                
                Button("Confirm", role: .destructive) {
                    deleteAllRecipes()
                    deleteConfirmationText = ""
                }
                .disabled(deleteConfirmationText != "delete")
            } message: {
                Text("This cannot be undone. Type delete if you're sure you want to delete all \(recipes.count) recipes.")
            }
            .onAppear {
                currentIconName = UIApplication.shared.alternateIconName
            }
        }
    }
    
    private func deleteAllRecipes() {
        for recipe in recipes {
            modelContext.delete(recipe)
        }
    }
    
    private func changeAppIcon(to iconName: String?) {
        guard UIApplication.shared.supportsAlternateIcons else { return }
        
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Error setting alternate icon: \(error.localizedDescription)")
            } else {
                currentIconName = iconName
            }
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Recipe.self)
}
