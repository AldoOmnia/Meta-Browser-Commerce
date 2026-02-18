//
//  SettingsView.swift
//  Meta Browser Commerce
//
//  Manage 3rd party platform logins for automation
//

import SwiftUI

struct PlatformConnection: Identifiable {
    let id: String
    let name: String
    let icon: String
    let logoDomain: String?
    var isConnected: Bool

    var logoURL: URL? {
        guard let domain = logoDomain else { return nil }
        return URL(string: "https://logo.clearbit.com/\(domain)")
    }
}

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var platforms: [PlatformConnection] = [
        PlatformConnection(id: "amazon", name: "Amazon", icon: "cart.fill", logoDomain: "amazon.com", isConnected: false),
        PlatformConnection(id: "nike", name: "Nike", icon: "sportscourt.fill", logoDomain: "nike.com", isConnected: false),
        PlatformConnection(id: "target", name: "Target", icon: "scope", logoDomain: "target.com", isConnected: false),
        PlatformConnection(id: "walmart", name: "Walmart", icon: "bag.fill", logoDomain: "walmart.com", isConnected: false),
        PlatformConnection(id: "bestbuy", name: "Best Buy", icon: "tv.fill", logoDomain: "bestbuy.com", isConnected: false),
        PlatformConnection(id: "lacolombe", name: "La Colombe", icon: "cup.and.saucer.fill", logoDomain: "lacolombe.com", isConnected: false),
        PlatformConnection(id: "starbucks", name: "Starbucks", icon: "cup.and.saucer.fill", logoDomain: "starbucks.com", isConnected: false),
    ]
    @State private var platformToLogin: PlatformConnection?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Connected accounts enable automation across retailers. Sign in once to browse and shop hands-free.")
                        .font(.callout)
                        .foregroundStyle(AppTheme.textSecondary)
                        .padding(.bottom, 8)

                    ForEach($platforms) { $platform in
                        HStack(spacing: 16) {
                            PlatformLogoView(platform: platform)
                                .frame(width: 44, height: 44)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(platform.name)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppTheme.textPrimary)
                                Text(platform.isConnected ? "Connected" : "Not connected")
                                    .font(.caption)
                                    .foregroundStyle(platform.isConnected ? AppTheme.success : AppTheme.textTertiary)
                            }
                            Spacer()
                            if platform.isConnected {
                                Button("Disconnect") {
                                    PlatformConnectionStore.setConnected(platformId: platform.id, connected: false)
                                    platform.isConnected = false
                                }
                                .font(.callout)
                                .foregroundStyle(AppTheme.textTertiary)
                                Button("Reconnect") {
                                    platformToLogin = platform
                                }
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundStyle(AppTheme.accent)
                            } else {
                                Button("Connect") {
                                    platformToLogin = platform
                                }
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundStyle(AppTheme.accent)
                            }
                        }
                        .padding(16)
                        .background(AppTheme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding(24)
            }
            .background(AppTheme.background)
            .navigationTitle("Platform Logins")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(AppTheme.accent)
                }
            }
            .onAppear {
                syncPlatformStates()
            }
            .fullScreenCover(item: $platformToLogin) { platform in
                PlatformLoginView(platform: platform) {
                    PlatformConnectionStore.setConnected(platformId: platform.id, connected: true)
                    if let idx = platforms.firstIndex(where: { $0.id == platform.id }) {
                        platforms[idx].isConnected = true
                    }
                }
            }
        }
    }

    private func syncPlatformStates() {
        for id in PlatformConnectionStore.connectedPlatforms {
            if let idx = platforms.firstIndex(where: { $0.id == id }) {
                platforms[idx].isConnected = true
            }
        }
    }
}

struct PlatformLogoView: View {
    let platform: PlatformConnection

    var body: some View {
        Group {
            if let url = platform.logoURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: platform.icon)
                            .font(.title2)
                            .foregroundStyle(AppTheme.accent)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(AppTheme.accentBackground)
                    default:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(AppTheme.cardBackground)
                    }
                }
            } else {
                Image(systemName: platform.icon)
                    .font(.title2)
                    .foregroundStyle(AppTheme.accent)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppTheme.accentBackground)
            }
        }
    }
}

extension PlatformConnection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: PlatformConnection, rhs: PlatformConnection) -> Bool {
        lhs.id == rhs.id
    }
}
