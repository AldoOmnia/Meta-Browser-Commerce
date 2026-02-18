//
//  SearchResultsView.swift
//  Meta Browser Commerce
//

import SwiftUI

struct SearchResultsView: View {
    @EnvironmentObject var appState: AppState

    private let sampleResults: [ProductResult] = [
        ProductResult(
            title: "Nike Revolution 7",
            description: "Men's running shoes, multiple colors",
            price: 69.97,
            source: "Nike.com",
            imageURL: nil
        ),
        ProductResult(
            title: "Nike Air Zoom Pegasus",
            description: "Lightweight, responsive cushioning",
            price: 79.99,
            source: "Amazon",
            imageURL: nil
        ),
        ProductResult(
            title: "Adidas Runfalcon 3",
            description: "Comfortable everyday runner",
            price: 64.99,
            source: "Target",
            imageURL: nil
        ),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Voice: \"Find running shoes under $80\"")
                            .font(.callout)
                            .foregroundStyle(AppTheme.textSecondary)
                        Text("Results from Nike, Amazon, Target")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                    .padding(.bottom, 4)

                    ForEach(sampleResults) { result in
                        ProductResultCard(product: result)
                    }

                    Text("Results spoken to your glasses • Tap for details or say \"compare\" / \"add to cart\"")
                        .font(.callout)
                        .foregroundStyle(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 12)
                }
                .padding(24)
            }
            .background(AppTheme.background)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProductResultCard: View {
    let product: ProductResult

    var body: some View {
        HStack(spacing: 18) {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackgroundElevated)
                .frame(width: 76, height: 76)

            VStack(alignment: .leading, spacing: 6) {
                Text(product.title)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.textPrimary)
                Text(product.description)
                    .font(.callout)
                    .foregroundStyle(AppTheme.textSecondary)
                Text("$\(NSDecimalNumber(decimal: product.price).doubleValue, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundStyle(AppTheme.accent)
                Text(product.source)
                    .font(.callout)
                    .foregroundStyle(AppTheme.textTertiary)
            }
            Spacer()
        }
        .padding(18)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
