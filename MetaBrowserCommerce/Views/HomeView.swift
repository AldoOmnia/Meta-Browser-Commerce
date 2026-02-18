//
//  HomeView.swift
//  Meta Browser Commerce
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState

    private let voiceExamples = [
        ("magnifyingglass", "Find running shoes under $80"),
        ("rectangle.on.rectangle.angled", "Compare iPhone and Pixel"),
        ("cart", "Add Nike Air Max to cart"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Meta Browser Commerce")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.textPrimary)
                        Text("Hands-free search and buy")
                            .font(.body)
                            .foregroundStyle(AppTheme.textSecondary)

                        if appState.isGlassesConnected {
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(AppTheme.success)
                                    .frame(width: 8, height: 8)
                                Text("Connected to Glasses")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppTheme.success)
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(AppTheme.success.opacity(0.18))
                            .clipShape(Capsule())
                            .padding(.top, 10)
                        }
                    }
                    .padding(.top, 8)

                    // Voice prompts
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Say on your glasses:")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(AppTheme.textSecondary)

                        ForEach(voiceExamples, id: \.1) { icon, phrase in
                            HStack(spacing: 16) {
                                Image(systemName: icon)
                                    .font(.title3)
                                    .foregroundStyle(AppTheme.accent)
                                    .frame(width: 40, height: 40)
                                    .background(AppTheme.accentBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                Text(phrase)
                                    .font(.body)
                                    .foregroundStyle(AppTheme.textPrimary)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(AppTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }

                    // Recent activity
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
                            Text("Running shoes — 12 results")
                                .font(.body)
                                .foregroundStyle(AppTheme.textPrimary)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        HStack(spacing: 16) {
                            Image(systemName: "iphone")
                                .font(.title3)
                                .foregroundStyle(AppTheme.accent)
                                .frame(width: 40, height: 40)
                                .background(AppTheme.accentBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Text("iPhone vs Pixel — compared")
                                .font(.body)
                                .foregroundStyle(AppTheme.textPrimary)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(AppTheme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(24)
            }
            .background(AppTheme.background)
        }
    }
}
