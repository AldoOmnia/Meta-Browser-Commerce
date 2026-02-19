//
//  GlassesStreamViewModel.swift
//  Meta Browser Commerce
//
//  Streams live video from Meta AI Glasses via DAT SDK.
//

import Foundation
import MWDATCamera
import MWDATCore
import SwiftUI

@MainActor
final class GlassesStreamViewModel: ObservableObject {
    @Published var currentVideoFrame: UIImage?
    @Published var hasReceivedFirstFrame = false
    @Published var isStreaming = false
    @Published var showError = false
    @Published var errorMessage = ""

    private let wearables: WearablesInterface
    private let deviceSelector: AutoDeviceSelector
    private var streamSession: StreamSession
    private var stateToken: AnyListenerToken?
    private var videoToken: AnyListenerToken?
    private var errorToken: AnyListenerToken?
    private var deviceMonitorTask: Task<Void, Never>?

    init(wearables: WearablesInterface = Wearables.shared) {
        self.wearables = wearables
        self.deviceSelector = AutoDeviceSelector(wearables: wearables)
        let config = StreamSessionConfig(
            videoCodec: .raw,
            resolution: .low,
            frameRate: 24
        )
        self.streamSession = StreamSession(streamSessionConfig: config, deviceSelector: deviceSelector)
        setupListeners()
    }

    private func setupListeners() {
        stateToken = streamSession.statePublisher.listen { [weak self] state in
            Task { @MainActor in
                self?.updateFromState(state)
            }
        }
        videoToken = streamSession.videoFramePublisher.listen { [weak self] frame in
            Task { @MainActor in
                if let image = frame.makeUIImage() {
                    self?.currentVideoFrame = image
                    self?.hasReceivedFirstFrame = true
                }
            }
        }
        errorToken = streamSession.errorPublisher.listen { [weak self] error in
            Task { @MainActor in
                self?.errorMessage = self?.formatError(error) ?? "Streaming error"
                self?.showError = true
            }
        }
    }

    private func updateFromState(_ state: StreamSessionState) {
        switch state {
        case .streaming:
            isStreaming = true
        case .stopped:
            isStreaming = false
            currentVideoFrame = nil
        default:
            break
        }
    }

    private func formatError(_ error: StreamSessionError) -> String {
        switch error {
        case .deviceNotFound: return "Glasses not found. Please ensure they're connected."
        case .deviceNotConnected: return "Glasses disconnected."
        case .timeout: return "Connection timed out."
        case .permissionDenied: return "Camera permission denied."
        case .hingesClosed: return "Open the glasses hinges to stream."
        default: return "Streaming error. Please try again."
        }
    }

    func startStreaming() async {
        do {
            let status = try await wearables.checkPermissionStatus(.camera)
            if status != .granted {
                let result = try await wearables.requestPermission(.camera)
                if result != .granted {
                    errorMessage = "Camera permission required"
                    showError = true
                    return
                }
            }
            await streamSession.start()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func stopStreaming() async {
        await streamSession.stop()
    }

    func dismissError() {
        showError = false
        errorMessage = ""
    }
}
