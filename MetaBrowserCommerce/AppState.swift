//
//  AppState.swift
//  Meta Browser Commerce
//

import Foundation

@MainActor
final class AppState: ObservableObject {
    // Meta DAT / Glasses connection
    @Published var isGlassesConnected = false
    @Published var isPairingInProgress = false
    /// True when user has paired or skipped — shows main app
    @Published var hasCompletedPairingFlow = false

    // Voice flow state
    @Published var lastVoiceQuery: String?
    @Published var searchResults: [ProductResult] = []
    @Published var comparisonItems: (ProductResult, ProductResult)?
    @Published var cart: [CartItem] = []

    // Navigation
    @Published var selectedTab: AppTab = .home
}

enum AppTab: String, CaseIterable {
    case home
    case search
    case compare
    case cart
}
