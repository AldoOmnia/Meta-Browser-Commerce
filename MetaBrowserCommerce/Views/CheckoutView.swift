//
//  CheckoutView.swift
//  Meta Browser Commerce
//
//  Single-screen checkout: review items, card on file, Apple Pay, Place Order.
//

import SwiftUI
import PassKit

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    @State private var showSuccess = false
    var items: [CartItem]?

    private var checkoutItems: [CartItem] {
        items ?? appState.cart
    }

    private var itemsBySource: [String: [CartItem]] {
        Dictionary(grouping: checkoutItems) { $0.product.source }
    }

    private var total: Decimal {
        checkoutItems.reduce(0) { $0 + $1.product.price * Decimal($1.quantity) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Items
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Items")
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)
                        ForEach(Array(itemsBySource.keys.sorted()), id: \.self) { source in
                            if let items = itemsBySource[source] {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(source)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(AppTheme.textSecondary)
                                    ForEach(items) { item in
                                        HStack {
                                            Text(item.product.title)
                                                .font(.body)
                                                .foregroundStyle(AppTheme.textPrimary)
                                            Spacer()
                                            Text("$\(NSDecimalNumber(decimal: item.product.price).doubleValue, specifier: "%.2f")")
                                                .font(.body)
                                                .foregroundStyle(AppTheme.accent)
                                        }
                                        .padding(12)
                                        .background(AppTheme.cardBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                    }

                    // Payment
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment")
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)
                        HStack(spacing: 14) {
                            Image(systemName: "creditcard.fill")
                                .font(.title2)
                                .foregroundStyle(AppTheme.accent)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Card on file")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundStyle(AppTheme.textPrimary)
                                Text("•••• •••• •••• 4242")
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.textSecondary)
                            }
                            Spacer()
                        }
                        .padding(16)
                        .background(AppTheme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        Text("Or pay with Apple Pay")
                            .font(.caption)
                            .foregroundStyle(AppTheme.textSecondary)
                        ApplePayButtonRepresentable()
                            .frame(height: 50)
                    }

                    // Total
                    HStack {
                        Text("Total")
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)
                        Spacer()
                        Text("$\(NSDecimalNumber(decimal: total).doubleValue, specifier: "%.2f")")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.accent)
                    }
                    .padding(.vertical, 8)
                }
                .padding(24)
            }
            .background(AppTheme.background)
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(AppTheme.textSecondary)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    showSuccess = true
                } label: {
                    Text("Place Order")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(AppTheme.accent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppTheme.background)
            }
            .alert("Order Complete", isPresented: $showSuccess) {
                Button("OK") {
                    if items == nil {
                        appState.cart.removeAll()
                    }
                    dismiss()
                }
            } message: {
                Text("Your order has been placed. Items will be shipped to your saved address.")
            }
        }
    }
}

/// Wraps PKPaymentButton for SwiftUI (Apple Pay manual checkout on phone)
private struct ApplePayButtonRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .white)
        return button
    }

    func updateUIView(_ uiView: PKPaymentButton, context: Context) {}
}
