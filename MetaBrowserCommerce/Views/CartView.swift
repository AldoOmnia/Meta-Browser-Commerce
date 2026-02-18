//
//  CartView.swift
//  Meta Browser Commerce
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCheckoutAlert = false

    private var sampleCartItems: [CartItem] {
        if appState.cart.isEmpty {
            return [
                CartItem(
                    product: ProductResult(
                        title: "Nike Revolution 7",
                        description: "Size 10",
                        price: 69.97,
                        source: "Nike",
                        imageURL: nil
                    ),
                    quantity: 1
                ),
                CartItem(
                    product: ProductResult(
                        title: "iPhone 16",
                        description: "128GB",
                        price: 799,
                        source: "Apple",
                        imageURL: nil
                    ),
                    quantity: 1
                ),
            ]
        }
        return appState.cart
    }

    private var total: Decimal {
        sampleCartItems.reduce(0) { $0 + $1.product.price * Decimal($1.quantity) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Added by voice on glasses")
                        .font(.callout)
                        .foregroundStyle(AppTheme.textSecondary)
                        .padding(.bottom, 4)

                    ForEach(sampleCartItems) { item in
                        HStack(spacing: 18) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppTheme.cardBackgroundElevated)
                                .frame(width: 68, height: 68)

                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.product.title)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppTheme.textPrimary)
                                Text("\(item.product.description) • $\(NSDecimalNumber(decimal: item.product.price).doubleValue, specifier: "%.2f")")
                                    .font(.callout)
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 18)
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(AppTheme.textTertiary.opacity(0.5)),
                            alignment: .bottom
                        )
                    }

                    Spacer(minLength: 24)

                    VStack(spacing: 18) {
                        HStack {
                            Text("Total")
                                .font(.headline)
                                .foregroundStyle(AppTheme.textPrimary)
                            Spacer()
                            Text("$\(NSDecimalNumber(decimal: total).doubleValue, specifier: "%.2f")")
                                .font(.headline)
                                .foregroundStyle(AppTheme.accent)
                        }
                        .padding(.vertical, 18)

                        Button {
                            showCheckoutAlert = true
                        } label: {
                            Text("Checkout")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(AppTheme.accent)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
                .padding(24)
            }
            .background(AppTheme.background)
            .navigationTitle("Your cart")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Checkout", isPresented: $showCheckoutAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Checkout flow coming soon. In production, this would complete the purchase.")
            }
        }
    }
}
