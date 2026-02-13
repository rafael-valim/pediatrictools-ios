import SwiftUI
import StoreKit

struct TipJarView: View {
    @Environment(TipJarManager.self) private var tipJarManager

    var body: some View {
        Form {
            Section {
                VStack(spacing: 8) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.pink)
                    if tipJarManager.isSupporter {
                        Text("tipjar_thank_you")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("tipjar_description")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }

            Section {
                if tipJarManager.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else if let error = tipJarManager.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .font(.subheadline)
                } else if tipJarManager.products.isEmpty {
                    Text("tipjar_no_products")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                } else {
                    ForEach(tipJarManager.products, id: \.id) { product in
                        Button {
                            Task { await tipJarManager.purchase(product) }
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(product.displayName)
                                        .font(.body.weight(.medium))
                                    Text(product.description)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(product.displayPrice)
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(.accent)
                            }
                        }
                        .disabled(tipJarManager.purchaseInProgress)
                    }
                }
            } header: {
                Text("tipjar_section_header")
            }

            Section {
                Button("tipjar_restore") {
                    Task { await tipJarManager.checkExistingPurchases() }
                }
            }
        }
        .navigationTitle("tipjar_nav_title")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await tipJarManager.loadProducts()
        }
    }
}
