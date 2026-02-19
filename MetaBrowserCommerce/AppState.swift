//
//  AppState.swift
//  Meta Browser Commerce
//

import Foundation

@MainActor
final class AppState: ObservableObject {
    /// Shown once at app launch
    @Published var hasSeenOmniaSplash = false
    /// Completed 3-step onboarding before pairing
    @Published var hasCompletedOnboarding = false

    /// Allow agents to complete purchases hands-free when connected
    @Published var allowAgentsToFinishCheckout = false

    // Meta DAT / Glasses connection
    @Published var isGlassesConnected = false
    @Published var isPairingInProgress = false
    /// True when user has paired or skipped — shows main app
    @Published var hasCompletedPairingFlow = false
    @Published var showPairingSheet = false
    @Published var showSettingsSheet = false

    // Voice flow state
    @Published var lastVoiceQuery: String?
    @Published var searchResults: [ProductResult] = []
    @Published var searchURL: URL?
    @Published var comparisonItems: (ProductResult, ProductResult)?
    @Published var cart: [CartItem] = []

    // Search session (browser + results flow)
    @Published var isSearchSessionPresented = false

    /// True when agent is actively browsing (live browser view visible)
    @Published var isBrowserAgentActive = false

    // Orders and pending checkout
    @Published var previousOrders: [PreviousOrder] = []
    /// Items added by agent that still need manual checkout
    @Published var pendingCheckoutItems: [CartItem] = []

    /// Previous agent actions: POV, prompt, browser result
    @Published var agentActions: [AgentAction] = []

    // Navigation
    @Published var selectedTab: AppTab = .home
}

struct AgentAction: Identifiable {
    let id = UUID()
    let prompt: String
    let povImageName: String?
    let browserURL: URL?
    let occurredAt: Date
}

struct PreviousOrder: Identifiable {
    let id = UUID()
    let platform: String
    let summary: String
    let date: Date
    let status: String
}

enum AppTab: String, CaseIterable {
    case home
    case browser
    case cart
}
