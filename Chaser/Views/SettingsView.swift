//
//  SettingsView.swift
//  Chaser
//
//  Created by GitHub Copilot on 2/16/26.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var recipes: [Recipe]
    
    @AppStorage("hideAutomaticParsing") private var hideAutomaticParsing = false
    @AppStorage("jsonImportExportEnabled") private var jsonImportExportEnabled = false
    @State private var showingDeleteConfirmation = false
    @State private var deleteConfirmationText = ""
    @State private var currentIconName: String?
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Recipe Editor")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Hide automatic parsing", isOn: $hideAutomaticParsing)
                        Text("If you're not a fan of automatic parsing, or if your device doesn't support it, you can disable the feature and it will no longer show up on the recipe editor.")
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
                                    IconSelector(icon: Icon.margarita, currentIconName: currentIconName)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                            Button(action: {
                                changeAppIcon(to: "OldFashioned")
                            }) {
                                VStack(spacing: 8) {
                                    IconSelector(icon: Icon.oldFashioned, currentIconName: currentIconName)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                            Button(action: {
                                changeAppIcon(to: "Tropical")
                            }) {
                                VStack(spacing: 8) {
                                    IconSelector(icon: Icon.tropical, currentIconName: currentIconName)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                            Button(action: {
                                changeAppIcon(to: "Collins")
                            }) {
                                VStack(spacing: 8) {
                                    IconSelector(icon: Icon.collins, currentIconName: currentIconName)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                            Button(action: {
                                changeAppIcon(to: "PintGlass")
                            }) {
                                VStack(spacing: 8) {
                                    IconSelector(icon: Icon.pintGlass, currentIconName: currentIconName)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                            Button(action: {
                                changeAppIcon(to: "WineGlass")
                            }) {
                                VStack(spacing: 8) {
                                    IconSelector(icon: Icon.wineGlass, currentIconName: currentIconName)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                            Button(action: {
                                changeAppIcon(to: "ShotGlass")
                            }) {
                                VStack(spacing: 8) {
                                    IconSelector(icon: Icon.shotGlass, currentIconName: currentIconName)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                        .padding(.vertical, 8)
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
                Text("This cannot be undone. Type delete if you're sure you want to delete all recipes.")
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
