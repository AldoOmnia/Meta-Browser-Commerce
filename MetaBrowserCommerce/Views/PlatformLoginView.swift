//
//  PlatformLoginView.swift
//  Meta Browser Commerce
//
//  WebView-based login for retailers.
//  Note: Amazon often blocks in-app WebView login for security.
//  Use "Open in Safari" fallback if sign-in fails.
//

import SwiftUI
import WebKit

struct PlatformLoginView: View {
    let platform: PlatformConnection
    let onComplete: () -> Void
    @Environment(\.dismiss) private var dismiss

    private var loginURL: URL {
        switch platform.id {
        case "amazon":
            return URL(string: "https://www.amazon.com/ap/signin")!
        case "nike":
            return URL(string: "https://www.nike.com/login")!
        case "target":
            return URL(string: "https://www.target.com/account")!
        case "walmart":
            return URL(string: "https://www.walmart.com/account/login")!
        case "bestbuy":
            return URL(string: "https://www.bestbuy.com/identity/signin")!
        case "lacolombe":
            return URL(string: "https://www.lacolombe.com/account/login")!
        case "starbucks":
            return URL(string: "https://www.starbucks.com/account/signin")!
        default:
            return URL(string: "https://www.amazon.com/ap/signin")!
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                PlatformLoginWebView(
                    url: loginURL,
                    platformId: platform.id,
                    onLoginDetected: onComplete
                )

                if platform.id == "amazon" {
                    Text("Amazon may block in-app login. If sign-in fails, use Safari.")
                        .font(.caption)
                        .foregroundStyle(AppTheme.textTertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                    Button("Open in Safari instead") {
                        UIApplication.shared.open(loginURL)
                    }
                    .font(.callout)
                    .foregroundStyle(AppTheme.accent)
                    .padding(.top, 4)
                }
            }
            .background(AppTheme.background)
            .navigationTitle("Sign in to \(platform.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(AppTheme.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onComplete()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.accent)
                }
            }
        }
    }
}

struct PlatformLoginWebView: UIViewRepresentable {
    let url: URL
    let platformId: String
    let onLoginDetected: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onLoginDetected: onLoginDetected, platformId: platformId)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.applicationNameForUserAgent = "Safari/605.1"

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    class Coordinator: NSObject, WKNavigationDelegate {
        let onLoginDetected: () -> Void
        let platformId: String

        init(onLoginDetected: @escaping () -> Void, platformId: String) {
            self.onLoginDetected = onLoginDetected
            self.platformId = platformId
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let url = webView.url?.absoluteString else { return }

            switch platformId {
            case "amazon":
                if url.contains("amazon.com") && !url.contains("/ap/signin") {
                    onLoginDetected()
                }
            case "nike":
                if url.contains("nike.com") && !url.contains("/login") {
                    onLoginDetected()
                }
            default:
                break
            }
        }
    }
}
