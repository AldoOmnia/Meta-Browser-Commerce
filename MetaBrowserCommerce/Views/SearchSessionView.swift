//
//  SearchSessionView.swift
//  Meta Browser Commerce
//
//  Flow: Camera/voice → Results → Confirm choice → Add to cart → Checkout
//

import SwiftUI
import WebKit

struct SearchSessionView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var productToConfirm: ProductResult?
    @State private var showConfirmSheet = false
    @State private var platformToBrowse: String?

    private var platformBrowseButtons: some View {
        Group {
            if PlatformConnectionStore.isConnected(platformId: "amazon") {
                platformBrowseCard(platform: "Amazon", color: Color.orange) {
                    platformToBrowse = "amazon"
                }
            }
            if PlatformConnectionStore.isConnected(platformId: "nike") {
                platformBrowseCard(platform: "Nike", color: Color.black) {
                    platformToBrowse = "nike"
                }
            }
            if PlatformConnectionStore.isConnected(platformId: "lacolombe") {
                platformBrowseCard(platform: "La Colombe", color: Color(red: 0.4, green: 0.25, blue: 0.1)) {
                    platformToBrowse = "lacolombe"
                }
            }
            if PlatformConnectionStore.isConnected(platformId: "starbucks") {
                platformBrowseCard(platform: "Starbucks", color: Color(red: 0.0, green: 0.35, blue: 0.2)) {
                    platformToBrowse = "starbucks"
                }
            }
            if PlatformConnectionStore.isConnected(platformId: "ubereats") {
                platformBrowseCard(platform: "Uber Eats", color: Color(red: 0.11, green: 0.85, blue: 0.36)) {
                    platformToBrowse = "ubereats"
                }
            }
        }
    }

    private func platformBrowseCard(platform: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "cart.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Browse on \(platform)")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text("Logged in — shop with your account")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.9))
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(16)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Flow prompt
                    HStack(spacing: 12) {
                        Image(systemName: "glasses")
                            .font(.title2)
                            .foregroundStyle(AppTheme.accent)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Camera opened • Say \"compare\" or \"find cheaper alternative\"")
                                .font(.callout)
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    if let query = appState.lastVoiceQuery {
                        Text("Results for: \"\(query)\"")
                            .font(.callout)
                            .foregroundStyle(AppTheme.textSecondary)
                    }

                    platformBrowseButtons

                    Text("Tap to confirm & add to cart")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(AppTheme.textPrimary)

                    ForEach(appState.searchResults) { result in
                        Button {
                            productToConfirm = result
                            showConfirmSheet = true
                        } label: {
                            ProductResultCard(product: result)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(24)
            }
            .background(AppTheme.background)
            .navigationTitle("Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(AppTheme.accent)
                }
            }
            .fullScreenCover(item: Binding(
                get: { platformToBrowse.map { BrowsePlatform(id: $0) } },
                set: { platformToBrowse = $0?.id }
            )) { platform in
                PlatformBrowseView(platformId: platform.id, searchQuery: appState.lastVoiceQuery)
            }
            .confirmationDialog("Add to Cart?", isPresented: $showConfirmSheet) {
                if let product = productToConfirm {
                    Button("Add \(product.title) to cart") {
                        appState.cart.append(CartItem(product: product, quantity: 1))
                        appState.selectedTab = .cart
                        productToConfirm = nil
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) {
                        productToConfirm = nil
                    }
                }
            } message: {
                if let product = productToConfirm {
                    Text("Add \(product.title) (\(product.source)) – $\(NSDecimalNumber(decimal: product.price).doubleValue, specifier: "%.2f") to your cart?")
                }
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}
