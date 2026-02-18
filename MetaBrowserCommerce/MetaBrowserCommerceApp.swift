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

    init() {
        configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
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
