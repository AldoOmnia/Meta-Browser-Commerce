//
//  PairingView.swift
//  Meta Browser Commerce
//
//  Connect Meta AI Glasses via Meta DAT SDK
//

import SwiftUI

struct PairingView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var wearablesBridge: WearablesBridge

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Glasses image
                Image("Glasses")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 260, height: 130)
                    .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 8)

                VStack(spacing: 16) {
                    Text("Connect Meta AI Glasses")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(AppTheme.textPrimary)

                    // Pairing steps (reduced width for better fit)
                    VStack(alignment: .leading, spacing: 12) {
                        pairingStep(number: 1, text: "Put your glasses in pairing mode")
                        pairingStep(number: 2, text: "Tap Pair Glasses below")
                        pairingStep(number: 3, text: "Follow the on-screen prompts")
                    }
                    .frame(maxWidth: 280, alignment: .leading)
                    .padding(18)
                    .background(AppTheme.cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    HStack(spacing: 8) {
                        Circle()
                            .fill(AppTheme.accent)
                            .frame(width: 14, height: 14)
                            .opacity(appState.isPairingInProgress ? 0.6 : 1)
                            .scaleEffect(appState.isPairingInProgress ? 1.2 : 1)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: appState.isPairingInProgress)
                        Text(appState.isPairingInProgress ? "Searching for glasses..." : "Ready to connect")
                            .font(.callout)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        pairGlasses()
                    } label: {
                        Text("Pair Glasses")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(AppTheme.accent)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(appState.isPairingInProgress)

                    Button {
                        skipPairing()
                    } label: {
                        Text("Skip — Use Phone Only")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

                // Powered by (above logo, like splash)
                VStack(spacing: 6) {
                    Text("Powered by")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.textTertiary)
                    Image("OmniaLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 18)
                }
                .padding(.bottom, 24)
            }
        }
    }

    private func pairGlasses() {
        appState.isPairingInProgress = true
        Task { @MainActor in
            do {
                try await wearablesBridge.startRegistration()
                // Registration started — Meta AI app will handle Connect flow.
                // WearablesBridge observes devicesStream; when device connects,
                // isGlassesConnected updates automatically.
                appState.hasCompletedPairingFlow = true
            } catch {
                appState.isPairingInProgress = false
                // Registration failed — user may need to open Meta AI app
                #if DEBUG
                print("[PairingView] Registration error: \(error)")
                #endif
            }
            appState.isPairingInProgress = false
        }
    }

    private func skipPairing() {
        appState.isPairingInProgress = false
        appState.hasCompletedPairingFlow = true
    }

    private func pairingStep(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(AppTheme.accent)
                .clipShape(Circle())
            Text(text)
                .font(.callout)
                .foregroundStyle(AppTheme.textPrimary)
            Spacer(minLength: 0)
        }
    }
}
