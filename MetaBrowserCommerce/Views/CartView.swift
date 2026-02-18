//
//  CartView.swift
//  Meta Browser Commerce
//
//  Two functions: (1) Previous orders by platform, (2) Pending checkout summary for items agent didn't complete
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var appState: AppState
    @State private var showCheckout = false
    @State private var checkoutItemsSource: CheckoutSource = .cart

    private var cartItems: [CartItem] {
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

    private var pendingItems: [CartItem] {
        appState.pendingCheckoutItems.isEmpty ? [] : appState.pendingCheckoutItems
    }

    private var previousOrders: [PreviousOrder] {
        if appState.previousOrders.isEmpty {
            return [
                PreviousOrder(platform: "Amazon", summary: "Running shoes, headphones", date: Date(), status: "Delivered"),
                PreviousOrder(platform: "Nike", summary: "Nike Revolution 7", date: Date().addingTimeInterval(-86400 * 3), status: "Shipped"),
            ]
        }
        return appState.previousOrders
    }

    private var itemsForCheckout: [CartItem]? {
        switch checkoutItemsSource {
        case .cart: return appState.cart.isEmpty ? cartItems : appState.cart
        case .pending: return pendingItems
        }
    }

    private var total: Decimal {
        cartItems.reduce(0) { $0 + $1.product.price * Decimal($1.quantity) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // Section 1: Current cart (added by agent / voice)
                    currentCartSection

                    // Section 2: Pending checkout — items agent couldn't complete
                    if !pendingItems.isEmpty {
                        pendingCheckoutSection
                    }

                    // Section 3: Previous orders by platform
                    previousOrdersSection
                }
                .padding(24)
            }
            .background(AppTheme.background)
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showCheckout) {
                CheckoutView(items: itemsForCheckout)
            }
        }
    }

    private var currentCartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("In your cart")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.textSecondary)

            Text("Added by voice on glasses")
                .font(.caption)
                .foregroundStyle(AppTheme.textTertiary)
                .padding(.bottom, 4)

            ForEach(cartItems) { item in
                HStack(spacing: 18) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppTheme.cardBackgroundElevated)
                        .frame(width: 68, height: 68)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.product.title)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppTheme.textPrimary)
                        Text("\(item.product.description) • \(item.product.source) • $\(NSDecimalNumber(decimal: item.product.price).doubleValue, specifier: "%.2f")")
                            .font(.callout)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    Spacer()
                }
                .padding(.vertical, 12)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(AppTheme.textTertiary.opacity(0.5)),
                    alignment: .bottom
                )
            }

            if !cartItems.isEmpty {
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
                    .padding(.vertical, 8)

                    Button {
                        checkoutItemsSource = .cart
                        showCheckout = true
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
        }
    }

    private var pendingCheckoutSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Finish checkout in app")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.textSecondary)

            Text("Some items couldn't be purchased by the agent. Complete checkout here.")
                .font(.caption)
                .foregroundStyle(AppTheme.textTertiary)

            ForEach(pendingItems) { item in
                HStack(spacing: 14) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppTheme.cardBackgroundElevated)
                        .frame(width: 52, height: 52)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.product.title)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundStyle(AppTheme.textPrimary)
                        Text("\(item.product.source) • $\(NSDecimalNumber(decimal: item.product.price).doubleValue, specifier: "%.2f")")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    Spacer()
                }
                .padding(14)
                .background(AppTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button {
                checkoutItemsSource = .pending
                showCheckout = true
            } label: {
                Text("Complete purchase")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppTheme.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var previousOrdersSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Previous orders")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.textSecondary)

            Text("Orders by platform")
                .font(.caption)
                .foregroundStyle(AppTheme.textTertiary)
                .padding(.bottom, 4)

            ForEach(previousOrders) { order in
                HStack(spacing: 14) {
                    Image(systemName: "shippingbox.fill")
                        .font(.title3)
                        .foregroundStyle(AppTheme.accent)
                        .frame(width: 40, height: 40)
                        .background(AppTheme.accentBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(order.platform)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppTheme.textPrimary)
                        Text(order.summary)
                            .font(.callout)
                            .foregroundStyle(AppTheme.textSecondary)
                        Text(order.status)
                            .font(.caption2)
                            .foregroundStyle(AppTheme.success)
                    }
                    Spacer()
                    Text(order.date, style: .date)
                        .font(.caption2)
                        .foregroundStyle(AppTheme.textTertiary)
                }
                .padding(16)
                .background(AppTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
}

private enum CheckoutSource {
    case cart
    case pending
}
