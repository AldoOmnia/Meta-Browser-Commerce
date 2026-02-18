//
//  CompareView.swift
//  Meta Browser Commerce
//

import SwiftUI

struct CompareView: View {
    @EnvironmentObject var appState: AppState

    private let iphone = ProductResult(
        title: "iPhone 16",
        description: "6.1\" • A18 • 128GB",
        price: 799,
        source: "Apple",
        imageURL: nil
    )
    private let pixel = ProductResult(
        title: "Google Pixel 9",
        description: "6.3\" • Tensor G4 • 128GB",
        price: 799,
        source: "Google",
        imageURL: nil
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Voice: \"Compare iPhone and Pixel\"")
                            .font(.callout)
                            .foregroundStyle(AppTheme.textSecondary)
                        Text("Side-by-side comparison")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                    .padding(.bottom, 4)

                    HStack(spacing: 16) {
                        CompareCard(product: iphone)
                        CompareCard(product: pixel)
                    }

                    Text("Comparison spoken to your glasses. Say \"add iPhone to cart\" or \"add Pixel to cart.\"")
                        .font(.callout)
                        .foregroundStyle(AppTheme.textSecondary)
                        .padding(.top, 8)

                    Button {
                        addToCart(iphone)
                    } label: {
                        Text("Add iPhone to Cart")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(AppTheme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    Button {
                        addToCart(pixel)
                    } label: {
                        Text("Add Pixel to Cart")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }
                .padding(24)
            }
            .background(AppTheme.background)
            .navigationTitle("Compare")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func addToCart(_ product: ProductResult) {
        appState.cart.append(CartItem(product: product, quantity: 1))
        appState.selectedTab = .cart
    }
}

struct CompareCard: View {
    let product: ProductResult

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackgroundElevated)
                .aspectRatio(1, contentMode: .fit)

            Text(product.title)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.textPrimary)
            Text(product.description)
                .font(.callout)
                .foregroundStyle(AppTheme.textSecondary)
            Text("$\(NSDecimalNumber(decimal: product.price).doubleValue, specifier: "%.0f")")
                .font(.headline)
                .foregroundStyle(AppTheme.accent)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
