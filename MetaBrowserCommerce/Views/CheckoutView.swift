//
//  CheckoutView.swift
//  Meta Browser Commerce
//

import SwiftUI

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    @State private var step = 1
    @State private var showSuccess = false
    var items: [CartItem]?

    private var checkoutItems: [CartItem] {
        items ?? appState.cart
    }
    private let steps = ["Review", "Payment", "Confirm"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Step indicator
                HStack(spacing: 8) {
                    ForEach(1...3, id: \.self) { i in
                        Circle()
                            .fill(i <= step ? AppTheme.accent : AppTheme.textTertiary)
                            .frame(width: 10, height: 10)
                        if i < 3 {
                            Rectangle()
                                .fill(i < step ? AppTheme.accent : AppTheme.textTertiary)
                                .frame(height: 2)
                        }
                    }
                }
                .padding(.horizontal, 40)

                Spacer()

                if step == 1 {
                    reviewStep
                } else if step == 2 {
                    paymentStep
                } else {
                    confirmStep
                }

                Spacer()

                Button(step < 3 ? "Continue" : "Place Order") {
                    if step < 3 {
                        step += 1
                    } else {
                        showSuccess = true
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(AppTheme.accent)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(24)
            .background(AppTheme.background)
            .navigationTitle(steps[step - 1])
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(AppTheme.textSecondary)
                }
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

    private var itemsBySource: [String: [CartItem]] {
        Dictionary(grouping: checkoutItems) { $0.product.source }
    }

    private var reviewStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Review your items")
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)

            ForEach(Array(itemsBySource.keys.sorted()), id: \.self) { source in
                if let items = itemsBySource[source] {
                    VStack(alignment: .leading, spacing: 10) {
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
                            .padding()
                            .background(AppTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var paymentStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Payment method")
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)
            Text("•••• •••• •••• 4242")
                .font(.body)
                .foregroundStyle(AppTheme.textSecondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var confirmStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Confirm order")
                .font(.headline)
                .foregroundStyle(AppTheme.textPrimary)
            Text("Total: $\(NSDecimalNumber(decimal: checkoutItems.reduce(0) { $0 + $1.product.price * Decimal($1.quantity) }).doubleValue, specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(AppTheme.accent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
