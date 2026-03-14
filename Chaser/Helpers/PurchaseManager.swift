//
//  PurchaseManager.swift
//  Chaser
//
//  Created by Andrew Whipple on 3/5/26.
//

import Foundation
import StoreKit
import OSLog

@MainActor
class PurchaseManager: ObservableObject {
    
    private let customIconId = "custom_icon__7bf84ab8_4d2c_4e75_a94d_e5e185726fc5"
    private let bonusRecipesId = "bonus_recipes__ccc39947_ba76_4f1c_90e2_2fdecd63f705"
    private let oneDollarTipId = "tip__6f71ea4b_f575_485d_a500_481b4a1163f8"
    
    private var productIds = [] as [String]
    
    @Published
    private(set) var products: [Product] = []
    private(set) var purchasedProductIDs = Set<String>()
    var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    
    var hasUnlockedCustomIcons: Bool {
        return purchasedProductIDs.contains(customIconId)
    }
    
    var customIconProduct: Product? {
        products.first(where: { $0.id == customIconId })
    }
    var bonusRecipesProduct: Product? {
        products.first(where: { $0.id == bonusRecipesId })
    }
    var oneDollarTipProduct: Product? {
        products.first(where: { $0.id == oneDollarTipId })
    }
    
    var hasUnlockedBonusRecipes: Bool {
        return purchasedProductIDs.contains(bonusRecipesId)
    }
    
    init() {
        Logger.iap.info("Attempting init of purchasemanager")
        productIds = [customIconId, bonusRecipesId, oneDollarTipId]
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    func loadProducts() async throws {
        Logger.iap.info("Attempting load of products")
        guard !self.productsLoaded else { return }
        do {
            self.products = try await Product.products(for: productIds)
        } catch {
            Logger.iap.error("Error loading products \(error.localizedDescription)")
        }
        self.productsLoaded = true
        Logger.iap.info("Products loaded \(self.products)")
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case let .success(.verified(transaction)):
            await transaction.finish()
            await self.updatePurchasedProducts()
        case let .success(.unverified(_, error)):
            break
        case .pending:
            break
        case .userCancelled:
            break
        @unknown default:
            break
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await verificationResult in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
    
    
    
    
}
