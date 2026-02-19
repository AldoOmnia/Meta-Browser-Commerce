//
//  GlassesPOVStreamView.swift
//  Meta Browser Commerce
//
//  Displays live stream from Meta AI Glasses when paired.
//  Same chrome as iPhoneCameraView: LIVE, Glasses POV, chat commands, Cancel.
//

import SwiftUI

struct GlassesPOVStreamView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = GlassesStreamViewModel()
    var initialCommand: String?
    var commands: [String]

    var body: some View {
        ZStack(alignment: .bottom) {
            // Video from glasses
            videoBackground

            // Top: LIVE + Glasses POV
            VStack {
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        Text("LIVE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .padding(.leading, 20)
                    .padding(.top, 60)

                    Spacer()

                    Text("Glasses POV")
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.trailing, 20)
                        .padding(.top, 60)
                }
                Spacer()
            }

            // Bottom: chat + Cancel (same as iPhoneCameraView)
            POVBottomChrome(commands: commands, onCancel: {
                dismiss()
            })
        }
        .background(Color.black)
        .task {
            await viewModel.startStreaming()
        }
        .onDisappear {
            Task { await viewModel.stopStreaming() }
        }
        .alert("Streaming Error", isPresented: $viewModel.showError) {
            Button("OK") { viewModel.dismissError() }
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    @ViewBuilder
    private var videoBackground: some View {
        if let frame = viewModel.currentVideoFrame, viewModel.hasReceivedFirstFrame {
            GeometryReader { geo in
                Image(uiImage: frame)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
            }
            .ignoresSafeArea()
        } else {
            Color.black
                .overlay {
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                        Text("Connecting to glasses...")
                            .font(.callout)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .ignoresSafeArea()
        }
    }
}

/// Shared bottom chrome: chat commands + Cancel (used by both iPhone and Glasses POV)
struct POVBottomChrome: View {
    let commands: [String]
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(commands.enumerated()), id: \.offset) { idx, cmd in
                            HStack {
                                Text(cmd)
                                    .font(.callout)
                                    .foregroundStyle(.white)
                                    .shadow(color: .black, radius: 2, x: 0, y: 1)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                Spacer(minLength: 40)
                            }
                            .id(idx)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .frame(maxHeight: 180)
                .onAppear {
                    if let lastIdx = commands.indices.last {
                        proxy.scrollTo(lastIdx, anchor: .bottom)
                    }
                }
                .onChange(of: commands.count) { _, _ in
                    if let lastIdx = commands.indices.last {
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(lastIdx, anchor: .bottom)
                        }
                    }
                }
            }

            Button(action: onCancel) {
                Text("Cancel")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.gray.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .padding(.top, 12)
        }
    }
}
