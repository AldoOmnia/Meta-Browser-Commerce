//
//  WearablesBridge.swift
//  Meta Browser Commerce
//
//  Bridges Meta Wearables DAT SDK with app state. Configures SDK at launch,
//  observes device connection, and drives isGlassesConnected.
//

import Foundation
import MWDATCore

@MainActor
final class WearablesBridge: ObservableObject {
    static let shared = WearablesBridge()

    /// True when at least one Meta glasses device is connected and available
    @Published private(set) var isGlassesConnected = false
    @Published private(set) var registrationState: RegistrationState = .unavailable

    private var deviceStreamTask: Task<Void, Never>?
    private var registrationStreamTask: Task<Void, Never>?
    private weak var appState: AppState?

    private init() {
        configure()
        startDeviceStream()
        startRegistrationStream()
    }

    /// Call once to sync connection state into AppState
    func bind(to appState: AppState) {
        self.appState = appState
        appState.isGlassesConnected = isGlassesConnected
    }

    private func configure() {
        do {
            try Wearables.configure()
        } catch {
            #if DEBUG
            print("[WearablesBridge] Configure failed: \(error)")
            #endif
        }
    }

    private func startDeviceStream() {
        deviceStreamTask = Task { @MainActor in
            for await devices in Wearables.shared.devicesStream() {
                let connected = !devices.isEmpty
                self.isGlassesConnected = connected
                self.appState?.isGlassesConnected = connected
            }
        }
    }

    private func startRegistrationStream() {
        registrationStreamTask = Task { @MainActor in
            for await state in Wearables.shared.registrationStateStream() {
                self.registrationState = state
            }
        }
    }

    /// Start Meta AI app registration flow (Connect in Meta AI app)
    func startRegistration() async throws {
        try await Wearables.shared.startRegistration()
    }

    /// Unregister from Meta AI
    func startUnregistration() async throws {
        try await Wearables.shared.startUnregistration()
    }

    var wearables: WearablesInterface { Wearables.shared }
}
