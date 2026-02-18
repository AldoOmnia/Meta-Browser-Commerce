//
//  PairingView.swift
//  Meta Browser Commerce
//
//  Connect Meta AI Glasses via Meta DAT SDK
//

import SwiftUI

struct PairingView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Glasses illustration
                RoundedRectangle(cornerRadius: 40)
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.cardBackground, AppTheme.cardBackgroundElevated],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 70)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(white: 0.15))
                            .frame(width: 80, height: 24)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(AppTheme.textTertiary, lineWidth: 2))
                    .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 8)

                VStack(spacing: 12) {
                    Circle()
                        .fill(AppTheme.accent)
                        .frame(width: 14, height: 14)
                        .opacity(appState.isPairingInProgress ? 0.6 : 1)
                        .scaleEffect(appState.isPairingInProgress ? 1.2 : 1)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: appState.isPairingInProgress)

                    Text("Connect Meta AI Glasses")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(AppTheme.textPrimary)

                    Text("Put your glasses in pairing mode and tap below to connect via Meta DAT")
                        .font(.callout)
                        .foregroundStyle(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
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
                .padding(.bottom, 48)
            }
        }
    }

    private func pairGlasses() {
        appState.isPairingInProgress = true
        // TODO: Integrate Meta Wearables DAT SDK
        // MetaWearablesSDK.shared.startPairing { result in ... }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            appState.isPairingInProgress = false
            appState.isGlassesConnected = true
            appState.hasCompletedPairingFlow = true
        }
    }

    private func skipPairing() {
        appState.isPairingInProgress = false
        appState.hasCompletedPairingFlow = true
    }
}
