//
//  MetaBrowserCommerceApp.swift
//  Meta Browser Commerce
//
//  Hands-free product search & purchase on Meta AI Glasses
//  Meta AI Grant Application
//

import SwiftUI

@main
struct MetaBrowserCommerceApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var wearablesBridge = WearablesBridge.shared

    init() {
        configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .environmentObject(wearablesBridge)
                .onAppear {
                    wearablesBridge.bind(to: appState)
                }
                .onOpenURL { url in
                    handleURL(url)
                }
        }
    }

    private func handleURL(_ url: URL) {
        guard url.scheme == "metabrowsercommerce",
              url.host == "search",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let query = components.queryItems?.first(where: { $0.name == "q" })?.value
        else { return }

        Task { @MainActor in
            let (searchURL, results) = SearchService.runSearch(query: query)
            appState.lastVoiceQuery = query
            appState.searchURL = searchURL
            appState.searchResults = results
            appState.isSearchSessionPresented = true
        }
    }

    private func configureAppearance() {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(AppTheme.background)
        navAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().tintColor = UIColor(AppTheme.accent)

        UITabBar.appearance().backgroundColor = UIColor(AppTheme.cardBackground)
        UITabBar.appearance().unselectedItemTintColor = UIColor(AppTheme.textSecondary)
        UITabBar.appearance().tintColor = UIColor(AppTheme.accent)
    }
}
