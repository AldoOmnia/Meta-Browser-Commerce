//
//  RootView.swift
//  Meta Browser Commerce
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if !appState.hasSeenOmniaSplash {
                OmniaSplashView()
            } else if !appState.hasCompletedOnboarding {
                OnboardingView()
            } else if !appState.hasCompletedPairingFlow {
                PairingView()
            } else {
                MainTabView()
            }
        }
        .fullScreenCover(isPresented: $appState.isSearchSessionPresented, onDismiss: { }) {
            SearchSessionView()
        }
        .onChange(of: appState.isSearchSessionPresented) { _, presented in
            if presented { appState.isBrowserAgentActive = true }
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

            BrowserLiveView()
                .tabItem { Label("Browser", systemImage: "globe") }
                .tag(AppTab.browser)

            CartView()
                .tabItem { Label("Cart", systemImage: "cart.fill") }
                .tag(AppTab.cart)
        }
        .tint(AppTheme.accent)
    }
}
