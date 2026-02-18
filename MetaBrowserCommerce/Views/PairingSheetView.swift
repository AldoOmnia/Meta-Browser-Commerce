//
//  PairingSheetView.swift
//  Meta Browser Commerce
//
//  Pairing UI shown as sheet when user taps "Pair Glasses" CTA
//

import SwiftUI

struct PairingSheetView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                Spacer()

                RoundedRectangle(cornerRadius: 40)
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.cardBackground, AppTheme.cardBackgroundElevated],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(white: 0.15))
                            .frame(width: 70, height: 20)
                    )
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(AppTheme.textTertiary, lineWidth: 2))

                VStack(spacing: 10) {
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
                    Text("Put glasses in pairing mode, then tap Pair")
                        .font(.callout)
                        .foregroundStyle(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
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

                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.callout)
                    .foregroundStyle(AppTheme.textSecondary)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(AppTheme.background)
        }
    }

    private func pairGlasses() {
        appState.isPairingInProgress = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            appState.isPairingInProgress = false
            appState.isGlassesConnected = true
            appState.showPairingSheet = false
            dismiss()
        }
    }
}
