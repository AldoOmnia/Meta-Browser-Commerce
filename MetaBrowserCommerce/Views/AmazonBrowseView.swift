//
//  AmazonBrowseView.swift
//  Meta Browser Commerce
//
//  Browse connected platforms with persisted login session
//

import SwiftUI
import WebKit

struct BrowsePlatform: Identifiable {
    let id: String
}

struct PlatformBrowseView: View {
    @Environment(\.dismiss) private var dismiss
    let platformId: String
    let searchQuery: String?

    private var title: String {
        switch platformId {
        case "amazon": return "Amazon"
        case "nike": return "Nike"
        case "lacolombe": return "La Colombe"
        case "starbucks": return "Starbucks"
        default: return "Browse"
        }
    }

    private var initialURL: URL {
        let term = SearchService.extractSearchTerm(from: searchQuery ?? "")
        switch platformId {
        case "amazon":
            if !term.isEmpty, let encoded = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return URL(string: "https://www.amazon.com/s?k=\(encoded)")!
            }
            return URL(string: "https://www.amazon.com")!
        case "nike":
            if !term.isEmpty, let encoded = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return URL(string: "https://www.nike.com/w?q=\(encoded)")!
            }
            return URL(string: "https://www.nike.com")!
        case "lacolombe":
            return URL(string: "https://www.lacolombe.com")!
        case "starbucks":
            return URL(string: "https://www.starbucks.com/store-locator")!
        default:
            return URL(string: "https://www.amazon.com")!
        }
    }

    var body: some View {
        NavigationStack {
            AmazonWebView(url: initialURL)
                .background(AppTheme.background)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundStyle(AppTheme.accent)
                    }
                }
        }
    }
}

struct AmazonBrowseView: View {
    @Environment(\.dismiss) private var dismiss
    let searchQuery: String?

    private var initialURL: URL {
        let term = SearchService.extractSearchTerm(from: searchQuery ?? "")
        if !term.isEmpty,
           let encoded = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: "https://www.amazon.com/s?k=\(encoded)")!
        }
        return URL(string: "https://www.amazon.com")!
    }

    var body: some View {
        NavigationStack {
            AmazonWebView(url: initialURL)
                .background(AppTheme.background)
                .navigationTitle("Amazon")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            dismiss()
                        }
                        .foregroundStyle(AppTheme.accent)
                    }
                }
        }
    }
}

struct AmazonWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}
