//
//  OnboardingView.swift
//  Meta Browser Commerce
//
//  3-step onboarding before the app: what it does, connect platforms, hands-free checkout demo.
//

import SwiftUI
import WebKit

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep = 0

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Step content
                TabView(selection: $currentStep) {
                    step1View.tag(0)
                    step2View.tag(1)
                    step3View.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(nil, value: currentStep)

                // Page indicator + buttons
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { i in
                            Circle()
                                .fill(i == currentStep ? AppTheme.accent : AppTheme.textTertiary)
                                .frame(width: 8, height: 8)
                        }
                    }

                    HStack(spacing: 16) {
                        if currentStep > 0 {
                            Button {
                                withAnimation { currentStep -= 1 }
                            } label: {
                                Text("Back")
                                    .font(.headline)
                                    .foregroundStyle(AppTheme.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            }
                        }
                        Button {
                            if currentStep < 2 {
                                withAnimation { currentStep += 1 }
                            } else {
                                completeOnboarding()
                            }
                        } label: {
                            Text(currentStep < 2 ? "Continue" : "Get Started")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(AppTheme.accent)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .padding(.top, 20)
            }
        }
    }

    /// Step 1: What the app does today
    private var step1View: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Spacer().frame(height: 40)
                Image("AppIconOnboarding")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 88, height: 88)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .frame(maxWidth: .infinity)

                Text("Hands-free search and buy")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Meta Browser Commerce lets you search, compare, and purchase products by voice on your Meta AI Glasses. Point at products, ask for recommendations, or add to cart — all without touching your phone.")
                    .font(.body)
                    .foregroundStyle(AppTheme.textSecondary)

                VStack(alignment: .leading, spacing: 12) {
                    onboardingBullet(icon: "magnifyingglass", text: "Search products by voice or camera")
                    onboardingBullet(icon: "rectangle.on.rectangle.angled", text: "Compare items and find best reviews")
                    onboardingBullet(icon: "cart.fill", text: "Add to cart and checkout hands-free")
                }
            }
            .padding(24)
        }
    }

    /// Step 2: Connect platforms
    private var step2View: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Spacer().frame(height: 40)
                Text("Connect your favorite retailers")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(AppTheme.textPrimary)

                Text("Link your accounts so agents can browse, add to cart, and complete purchases for you.")
                    .font(.body)
                    .foregroundStyle(AppTheme.textSecondary)

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    platformIconView(assetName: "AmazonLogo", name: "Amazon")
                    platformIconView(assetName: "StarbucksLogo", name: "Starbucks")
                    platformIconView(assetName: "TargetLogo", name: "Target")
                    platformIconView(assetName: "WalmartLogo", name: "Walmart")
                    platformIconView(assetName: "BestBuyLogo", name: "Best Buy")
                    platformIconView(assetName: "NikeLogo", name: "Nike")
                    platformIconView(assetName: "LaColombeLogo", name: "La Colombe")
                    platformIconView(assetName: "UberEatsLogo", name: "Uber Eats")
                }
                .padding(.vertical, 8)
            }
            .padding(24)
        }
    }

    /// Step 3: Voice prompt → Glasses POV → Agent in browser (clear flow for novices)
    private var step3View: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Spacer().frame(height: 24)
                Text("Agent performs checkout hands-free")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(AppTheme.textPrimary)
                    .padding(.horizontal, 24)

                Text("See the connection: your voice prompt → what the glasses see → how the agent completes the action.")
                    .font(.callout)
                    .foregroundStyle(AppTheme.textSecondary)
                    .padding(.horizontal, 24)

                // 1. Voice prompt (visible, connects everything)
                VStack(alignment: .leading, spacing: 8) {
                    Text("1. You say")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.textTertiary)
                    Text("\"Find me a similar product on Amazon\"")
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(AppTheme.textPrimary)
                        .italic()
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal, 24)

                // 2. Glasses POV — what the glasses see
                VStack(alignment: .leading, spacing: 8) {
                    Text("2. Glasses POV")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.textTertiary)
                    Image("AddToCart")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxHeight: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal, 24)

                // 3. Agent in browser — performs checkout
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 8) {
                        Text("3. Agent in browser")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.textTertiary)
                        Spacer()
                        Circle().fill(AppTheme.success).frame(width: 8, height: 8)
                        Text("Agent active")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppTheme.success)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppTheme.cardBackground)

                    OnboardingBrowserSection(onAddToCartResult: { _ in })
                        .frame(height: 320)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppTheme.accent.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)
                .padding(.top, 4)
            }
        }
    }

    private func onboardingBullet(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(AppTheme.accent)
                .frame(width: 24, alignment: .center)
            Text(text)
                .font(.body)
                .foregroundStyle(AppTheme.textPrimary)
        }
    }

    private func platformIconView(assetName: String, name: String) -> some View {
        VStack(spacing: 8) {
            Image(assetName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
                .background(AppTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(name)
                .font(.caption2)
                .foregroundStyle(AppTheme.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }

    private func platformIconView(logoDomain: String, name: String) -> some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: "https://logo.clearbit.com/\(logoDomain)")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                default:
                    Image(systemName: "bag.fill")
                        .font(.title2)
                        .foregroundStyle(AppTheme.accent)
                }
            }
            .frame(width: 48, height: 48)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            Text(name)
                .font(.caption2)
                .foregroundStyle(AppTheme.textSecondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }

    private func completeOnboarding() {
        withAnimation {
            appState.hasCompletedOnboarding = true
        }
    }
}

/// Real Amazon WebView — loads product page and injects JS to add to cart (browser-use test)
private struct OnboardingBrowserSection: View {
    @State private var status: AgentStatus = .loading
    var onAddToCartResult: (Bool) -> Void

    private enum AgentStatus {
        case loading
        case loaded
        case adding
        case success
        case failed
    }

    private static let amazonURL = URL(string: "https://www.amazon.com/dp/B09W737GFR")!

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image("AmazonLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 22)
                Spacer()
                HStack(spacing: 6) {
                    Circle()
                        .fill(status == .success ? AppTheme.success : (status == .failed ? Color.orange : AppTheme.accent))
                        .frame(width: 6, height: 6)
                    Text(statusText)
                        .font(.caption2)
                        .foregroundStyle(status == .success ? AppTheme.success : (status == .failed ? Color.orange : AppTheme.textSecondary))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(AppTheme.cardBackground)

            ZStack {
                OnboardingAmazonWebView(
                    url: Self.amazonURL,
                    onLoaded: { status = .loaded },
                    onAddToCartAttempt: { status = .adding },
                    onAddToCartResult: { success in
                        status = success ? .success : .failed
                        onAddToCartResult(success)
                    }
                )
                if status == .loading {
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.2)
                            .tint(AppTheme.accent)
                        Text("Loading Amazon...")
                            .font(.caption)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                }
            }
        }
    }

    private var statusText: String {
        switch status {
        case .loading: return "Loading..."
        case .loaded: return "Agent will add to cart..."
        case .adding: return "Adding to cart..."
        case .success: return "Added to cart"
        case .failed: return "Add to cart (sign in may be needed)"
        }
    }
}

/// WKWebView loading Amazon + JS injection to click Add to Cart
private struct OnboardingAmazonWebView: UIViewRepresentable {
    let url: URL
    let onLoaded: () -> Void
    let onAddToCartAttempt: () -> Void
    let onAddToCartResult: (Bool) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onLoaded: onLoaded, onAddToCartAttempt: onAddToCartAttempt, onAddToCartResult: onAddToCartResult)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        config.processPool = WKProcessPool()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.applicationNameForUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15"

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = true
        webView.isOpaque = true
        webView.backgroundColor = .white
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        let onLoaded: () -> Void
        let onAddToCartAttempt: () -> Void
        let onAddToCartResult: (Bool) -> Void
        var hasAttemptedAddToCart = false

        init(onLoaded: @escaping () -> Void, onAddToCartAttempt: @escaping () -> Void, onAddToCartResult: @escaping (Bool) -> Void) {
            self.onLoaded = onLoaded
            self.onAddToCartAttempt = onAddToCartAttempt
            self.onAddToCartResult = onAddToCartResult
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let url = webView.url?.absoluteString,
                  url.contains("amazon.com") else { return }

            onLoaded()

            // Only try on product page (not sign-in or other redirects)
            guard url.contains("/dp/") else { return }
            guard !hasAttemptedAddToCart else { return }
            hasAttemptedAddToCart = true

            // Wait for dynamic content (Add to Cart button), then inject click
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.onAddToCartAttempt()
                self.tryAddToCart(webView: webView)
            }
        }

        private func tryAddToCart(webView: WKWebView) {
            let script = """
            (function() {
                var selectors = ['#add-to-cart-button', 'input#add-to-cart-button', '[name="submit.add-to-cart"]', 'input[name="submit.add-to-cart"]', '#addToCart', 'input[id*="add-to-cart"]'];
                for (var i = 0; i < selectors.length; i++) {
                    var el = document.querySelector(selectors[i]);
                    if (el) { el.click(); return true; }
                }
                var inputs = document.querySelectorAll('input[type="submit"], input[type="button"]');
                for (var j = 0; j < inputs.length; j++) {
                    if (inputs[j].value && (inputs[j].value.includes('Add to Cart') || inputs[j].value.includes('Add to Basket'))) {
                        inputs[j].click(); return true;
                    }
                }
                return false;
            })();
            """
            webView.evaluateJavaScript(script) { result, error in
                DispatchQueue.main.async {
                    let success = (result as? Bool) ?? false
                    self.onAddToCartResult(success)
                }
            }
        }
    }
}
