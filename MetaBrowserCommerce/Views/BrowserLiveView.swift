//
//  BrowserLiveView.swift
//  Meta Browser Commerce
//
//  Live browser view with prompt, previous actions (POV, prompt, browser),
//  and close/back. Emphasizes live view when active.
//

import SwiftUI
import WebKit

struct BrowserLiveView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Current prompt
                    if let query = appState.lastVoiceQuery {
                        promptSection(query: query)
                    }

                    // Live browser (emphasized when active)
                    if appState.isBrowserAgentActive, let url = appState.searchURL {
                        liveBrowserSection(url: url)
                    } else {
                        browserPlaceholder
                    }

                    // Previous actions: POV, prompt, browser recording
                    if !appState.agentActions.isEmpty {
                        previousActionsSection
                    }
                }
                .padding(24)
            }
            .background(AppTheme.background)
            .navigationTitle("Agent Browser")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        appState.selectedTab = .home
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.body)
                            .foregroundStyle(AppTheme.accent)
                        Text("Back")
                            .foregroundStyle(AppTheme.accent)
                    }
                }
            }
        }
    }

    private func promptSection(query: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current prompt")
                .font(.caption)
                .foregroundStyle(AppTheme.textTertiary)
            Text(query)
                .font(.body)
                .fontWeight(.medium)
                .foregroundStyle(AppTheme.textPrimary)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(AppTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func liveBrowserSection(url: URL) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Circle().fill(AppTheme.success).frame(width: 8, height: 8)
                Text("Live")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppTheme.success)
            }

            WKWebViewRepresentable(url: url)
                .frame(height: 360)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppTheme.accent.opacity(0.3), lineWidth: 1)
                )
        }
    }

    private var browserPlaceholder: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Circle().fill(AppTheme.textTertiary).frame(width: 8, height: 8)
                Text("Waiting for agent")
                    .font(.caption)
                    .foregroundStyle(AppTheme.textTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 16) {
                Image("WhiteGlasses")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .opacity(0.6)
                Text("Say \"find running shoes\" or \"compare these two items\" to start")
                    .font(.callout)
                    .foregroundStyle(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 48)
            .background(AppTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var previousActionsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Previous actions")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(AppTheme.textSecondary)

            ForEach(appState.agentActions.reversed()) { action in
                AgentActionCard(action: action)
            }
        }
    }
}

struct AgentActionCard: View {
    let action: AgentAction

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // POV placeholder (glasses capture)
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.cardBackgroundElevated)
                    .aspectRatio(16/9, contentMode: .fit)
                Image("Glasses")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .opacity(0.5)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppTheme.textTertiary.opacity(0.3), lineWidth: 1)
            )

            Text(action.prompt)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(AppTheme.textPrimary)

            if let url = action.browserURL {
                Link(destination: url) {
                    HStack(spacing: 6) {
                        Image(systemName: "safari")
                            .font(.caption)
                        Text(url.host ?? url.absoluteString)
                            .font(.caption)
                            .lineLimit(1)
                        Image(systemName: "arrow.up.right")
                            .font(.caption2)
                    }
                    .foregroundStyle(AppTheme.accent)
                }
            }
        }
        .padding(16)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct WKWebViewRepresentable: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}
