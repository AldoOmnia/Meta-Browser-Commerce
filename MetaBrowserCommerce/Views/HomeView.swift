//
//  HomeView.swift
//  Meta Browser Commerce
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var testSearchQuery = ""
    @State private var showCamera = false
    @State private var cameraPresetQuery: String?
    @State private var showPairing = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header with connection status (card-style like media reference)
                    connectionCardSection

                    // Voice command card: large rectangle + Send to glasses
                    voiceCommandSection

                    // Actions guide with visuals
                    actionsGuideSection

                    // Recent activity
                    recentActivitySection
                }
                .padding(24)
            }
            .background(AppTheme.background)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        appState.showSettingsSheet = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundStyle(AppTheme.textPrimary)
                    }
                }
            }
            .toolbarBackground(AppTheme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $appState.showPairingSheet) { PairingSheetView() }
            .sheet(isPresented: $appState.showSettingsSheet) { SettingsView() }
            .fullScreenCover(isPresented: $showCamera) {
                iPhoneCameraView(presetQuery: cameraPresetQuery) { query in
                    runSearch(query)
                    cameraPresetQuery = nil
                }
            }
        }
    }

    /// Card-style connection status (similar to media.webp)
    private var connectionCardSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Meta Browser Commerce")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(AppTheme.textPrimary)
            Text("Hands-free search and buy")
                .font(.body)
                .foregroundStyle(AppTheme.textSecondary)

            // Connection card (tappable to start)
            Button {
                if appState.isGlassesConnected {
                    runSearch("Find running shoes")
                } else {
                    showCamera = true
                }
            } label: {
                HStack(spacing: 16) {
                Image("Glasses")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 56, height: 56)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(appState.isGlassesConnected ? "Connected to Glasses" : "Ready to pair")
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)
                        Text(appState.isGlassesConnected ? "Tap to start • Say \"Find running shoes\"" : "Tap to use iPhone camera")
                            .font(.caption)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    Spacer()
                    if appState.isGlassesConnected {
                        Circle().fill(AppTheme.success).frame(width: 10, height: 10)
                    } else {
                        Button("Pair") {
                            appState.showPairingSheet = true
                        }
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppTheme.accent)
                    }
                }
                .padding(18)
                .background(AppTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
    }

    private var voiceCommandSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Voice commands")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.textSecondary)

            VoiceCommandCardView(text: $testSearchQuery) { command in
                runSearch(command)
            }

            Text("Tap to type your own, or send an example to your glasses")
                .font(.caption2)
                .foregroundStyle(AppTheme.textTertiary)
        }
    }

    /// Actions guide with pictures — under search bar
    private var actionsGuideSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("What you can do")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.textSecondary)

            // Action 1: Camera + product search / compare
            ActionGuideCard(
                icon: "camera.viewfinder",
                title: "Camera & product search",
                examples: [
                    "Find me a similar product and add it to Amazon cart",
                    "Compare these two items and find the best match online"
                ],
                footnote: "System picks the best platform available."
            ) {
                showCamera = true
            }

            // Action 2: Agent + camera — room-aware shopping
            ActionGuideCard(
                icon: "camera.metering.center.weighted",
                title: "Agent + camera",
                examples: [
                    "Help me find options for a sofa that fits my living room"
                ],
                footnote: "Point your camera at the space — agent analyzes and finds fits."
            ) {
                cameraPresetQuery = "Help me find options for a sofa that fits my living room"
                showCamera = true
            }

            // Action 4: Compare
            ActionGuideCard(
                icon: "rectangle.on.rectangle.angled",
                title: "Compare products",
                examples: ["Compare iPhone and Pixel", "Find cheaper alternative"],
                footnote: nil
            ) {
                runSearch("Compare iPhone and Pixel")
            }

            // Action 5: Dining / pickup
            ActionGuideCard(
                icon: "cup.and.saucer.fill",
                title: "Dining & pickup orders",
                examples: [
                    "Place pickup at closest La Colombe",
                    "Order from Starbucks"
                ],
                footnote: "Tap to try La Colombe or Starbucks"
            ) {
                runDining("La Colombe")
            }
            HStack(spacing: 12) {
                Button { runDining("La Colombe") } label: {
                    Text("La Colombe").font(.callout).fontWeight(.medium)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(AppTheme.accentBackground).foregroundStyle(AppTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Button { runDining("Starbucks") } label: {
                    Text("Starbucks").font(.callout).fontWeight(.medium)
                        .frame(maxWidth: .infinity).padding(.vertical, 10)
                        .background(AppTheme.accentBackground).foregroundStyle(AppTheme.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }

    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Recent activity")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.textSecondary)

            HStack(spacing: 16) {
                Image(systemName: "shippingbox")
                    .font(.title3)
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 40, height: 40)
                    .background(AppTheme.accentBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("Running shoes — Nike + Amazon")
                    .font(.body)
                    .foregroundStyle(AppTheme.textPrimary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))

            HStack(spacing: 16) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.title3)
                    .foregroundStyle(AppTheme.accent)
                    .frame(width: 40, height: 40)
                    .background(AppTheme.accentBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("La Colombe — pickup ready")
                    .font(.body)
                    .foregroundStyle(AppTheme.textPrimary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private func runSearch(_ query: String) {
        let (url, results) = SearchService.runSearch(query: query)
        appState.lastVoiceQuery = query
        appState.searchURL = url
        appState.searchResults = results
        appState.isSearchSessionPresented = true
        appState.agentActions.append(AgentAction(prompt: query, povImageName: nil, browserURL: url, occurredAt: Date()))
    }

    private func runDining(_ venue: String) {
        let (url, results) = SearchService.runDiningOrder(venue: venue)
        let query = "Order from \(venue)"
        appState.lastVoiceQuery = query
        appState.searchURL = url
        appState.searchResults = results
        appState.isSearchSessionPresented = true
        appState.agentActions.append(AgentAction(prompt: query, povImageName: nil, browserURL: url, occurredAt: Date()))
    }
}

/// Action card with icons (pictures), example voice commands in quotes, glasses icon
struct ActionGuideCard: View {
    let icon: String
    let title: String
    let examples: [String]
    let footnote: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 14) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(AppTheme.accent)
                        .frame(width: 48, height: 48)
                        .background(AppTheme.accentBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(AppTheme.textPrimary)

                        ForEach(examples, id: \.self) { ex in
                            (Text("Try saying ") + Text("\"\(ex)\"").italic())
                                .font(.caption)
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                        if let footnote {
                            Text(footnote)
                                .font(.caption2)
                                .foregroundStyle(AppTheme.textTertiary)
                        }
                    }
                    Spacer()
                    Image("WhiteGlasses")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
                .padding(16)
            }
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}
