//
//  SampleRecipesView.swift
//  Chaser
//
//  Created by Andrew Whipple on 2/6/26.
//

import SwiftUI

struct SampleRecipesView: View {
    @Binding var recipes: [Recipe]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var purchaseManager: PurchaseManager

    @State private var selectedTab = 0
    @State private var isPurchasingBonusRecipes = false
    private let sampleLibrary = SampleRecipeLibrary.shared


    private func isRecipeInLibrary(sampleRecipe: Recipe) -> Bool {
        recipes.contains { $0.sourceRecipeId == sampleRecipe.id }
    }


    private func addToLibrary(sampleRecipe: Recipe) {
        let newRecipe = Recipe(
            name: sampleRecipe.name,
            ingredients: (sampleRecipe.ingredients ?? []).map { ingredient in
                Ingredient(name: ingredient.name, unit: ingredient.unit, amount: ingredient.amount)
            },
            instructions: sampleRecipe.instructions,
            tags: sampleRecipe.tags,
            sourceRecipeId: sampleRecipe.id
        )
        modelContext.insert(newRecipe)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ── Top tab bar ──────────────────────────────────────────────
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(Array(sampleLibrary.sections.enumerated()), id: \.offset) { index, section in
                            if !section.isGated || purchaseManager.bonusRecipesProduct != nil {
                                Button {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedTab = index
                                    }
                                } label: {
                                    VStack(spacing: 6) {
                                        Text(section.title)
                                            .font(.subheadline)
                                            .fontWeight(selectedTab == index ? .semibold : .regular)
                                            .foregroundColor(selectedTab == index ? .accentColor : .secondary)
                                            .padding(.horizontal, 16)
                                            .padding(.top, 10)

                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundColor(selectedTab == index ? .accentColor : .clear)
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .background(Color(UIColor.systemBackground))

                Divider()

                // ── Paged content ────────────────────────────────────────────
                TabView(selection: $selectedTab) {
                    ForEach(Array(sampleLibrary.sections.enumerated()), id: \.offset) { index, section in
                        sectionContent(for: section)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Inspiration")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Recipes")
                        }
                    }
                }
            }
        }
    }


    @ViewBuilder
    private func sectionContent(for section: SampleRecipeSection) -> some View {
        let locked = section.isGated && !purchaseManager.hasUnlockedBonusRecipes

        List {
            if locked {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Want to try some original recipes, courtesy of Chaser? Want to learn some of the formulas underlying your favorite cocktails?")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Button {
                            guard let product = purchaseManager.bonusRecipesProduct else { return }
                            isPurchasingBonusRecipes = true
                            Task {
                                defer { isPurchasingBonusRecipes = false }
                                try? await purchaseManager.purchase(product)
                            }
                        } label: {
                            HStack {
                                Spacer()
                                if isPurchasingBonusRecipes {
                                    ProgressView()
                                } else {
                                    let priceLabel = purchaseManager.bonusRecipesProduct
                                        .map { "Unlock Bonus Recipes \u{2014} \($0.displayPrice)" }
                                        ?? "Unlock Bonus Recipes"
                                    Text(priceLabel).bold()
                                }
                                Spacer()
                            }
                        }
                        .disabled(isPurchasingBonusRecipes || purchaseManager.bonusRecipesProduct == nil)
                    }
                }
            }

            // Recipe rows
            Section {
                ForEach(section.recipes, id: \.id) { recipe in
                    recipeRow(for: recipe, locked: locked)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Recipe row

    @ViewBuilder
    private func recipeRow(for recipe: Recipe, locked: Bool) -> some View {
        HStack {
            if locked {
                CardView(recipe: recipe)
                    .foregroundColor(.secondary)
            } else {
                NavigationLink(destination: SampleDetailView(
                    sampleRecipe: recipe,
                    recipes: $recipes
                )) {
                    CardView(recipe: recipe)
                }
            }

            Spacer()

            Button {
                addToLibrary(sampleRecipe: recipe)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(locked || isRecipeInLibrary(sampleRecipe: recipe) ? .gray : .accentColor)
            }
            .buttonStyle(BorderlessButtonStyle())
            .disabled(locked || isRecipeInLibrary(sampleRecipe: recipe))
            .accessibilityLabel(
                locked ? "Locked"
                : isRecipeInLibrary(sampleRecipe: recipe) ? "Already in library"
                : "Add to library"
            )
        }
    }
}

struct SampleRecipesView_Previews: PreviewProvider {
    static var previews: some View {
        SampleRecipesView(recipes: .constant([]))
    }
}
