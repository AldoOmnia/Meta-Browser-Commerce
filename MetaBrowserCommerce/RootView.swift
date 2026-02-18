//
//  RootView.swift
//  Meta Browser Commerce
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if !appState.hasCompletedPairingFlow {
            PairingView()
        } else {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(AppTab.home)

            SearchResultsView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
                .tag(AppTab.search)

            CompareView()
                .tabItem { Label("Compare", systemImage: "rectangle.on.rectangle.angled") }
                .tag(AppTab.compare)

            CartView()
                .tabItem { Label("Cart", systemImage: "cart.fill") }
                .tag(AppTab.cart)
        }
        .tint(AppTheme.accent)
    }
}
