import Foundation
import StoreKit

@Observable
final class TipJarManager {

    static let productIDs: [String] = [
        "com.RV.pediatrictools.app.tip.small",
        "com.RV.pediatrictools.app.tip.medium",
        "com.RV.pediatrictools.app.tip.large",
    ]

    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var purchaseInProgress = false

    var isSupporter: Bool {
        get { UserDefaults.standard.bool(forKey: "isSupporter") }
        set { UserDefaults.standard.set(newValue, forKey: "isSupporter") }
    }

    private var transactionListener: Task<Void, Never>?

    init() {
        transactionListener = listenForTransactions()
        Task { await checkExistingPurchases() }
    }

    deinit {
        transactionListener?.cancel()
    }

    @MainActor
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            let storeProducts = try await Product.products(for: Self.productIDs)
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func purchase(_ product: Product) async {
        purchaseInProgress = true
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    isSupporter = true
                    await transaction.finish()
                }
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        purchaseInProgress = false
    }

    @MainActor
    func checkExistingPurchases() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               Self.productIDs.contains(transaction.productID) {
                isSupporter = true
                return
            }
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await MainActor.run {
                        self?.isSupporter = true
                    }
                    await transaction.finish()
                }
            }
        }
    }
}
