//
//  iPhoneCameraView.swift
//
//  Camera view when Send to Glasses is clicked.
//  Shows live feed + voice commands in chat mode (from bottom).
//  Cancel button only — no glasses icons.
//

import SwiftUI
import AVFoundation

struct iPhoneCameraView: View {
    @Environment(\.dismiss) private var dismiss
    var initialCommand: String?
    var commands: [String]
    var onDismiss: (() -> Void)?
    var onSearch: ((String) -> Void)?

    var body: some View {
        ZStack(alignment: .bottom) {
            CameraPreviewView()
                .ignoresSafeArea()

            // Top: LIVE + Glasses POV (restored)
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

            // Bottom: chat + Cancel (shared with Glasses POV)
            POVBottomChrome(commands: commands) {
                onDismiss?()
                dismiss()
            }
        }
        .background(Color.black)
    }
}

/// Camera preview with proper layout for AVCaptureVideoPreviewLayer
struct CameraPreviewView: UIViewRepresentable {
    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.backgroundColor = .black

        let session = AVCaptureSession()
        session.sessionPreset = .high

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            return view
        }
        session.addInput(input)

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.previewLayer = previewLayer
        view.layer.addSublayer(previewLayer)

        context.coordinator.session = session
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }

        return view
    }

    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        uiView.previewLayer?.frame = uiView.bounds
    }

    func makeCoordinator() -> Coordinator { Coordinator() }
    class Coordinator {
        var session: AVCaptureSession?
    }
}

/// UIView that sizes preview layer in layoutSubviews (fixes camera not showing)
final class CameraPreviewUIView: UIView {
    var previewLayer: AVCaptureVideoPreviewLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}
