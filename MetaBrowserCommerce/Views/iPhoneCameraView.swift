//
//  iPhoneCameraView.swift
//  Meta Browser Commerce
//
//  Fallback camera when glasses aren't paired — like VisionClaw "Phone mode"
//

import SwiftUI
import AVFoundation

struct iPhoneCameraView: View {
    @Environment(\.dismiss) private var dismiss
    var presetQuery: String?
    var onSearch: (String) -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                CameraPreviewView()
                    .ignoresSafeArea()

                VStack {
                    Spacer()
                    HStack(spacing: 20) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundStyle(.white)
                        .font(.callout)

                        Button {
                            onSearch(presetQuery ?? "Search what I see")
                            dismiss()
                        } label: {
                            Image("WhiteGlasses")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 64, height: 64)
                                .padding(12)
                                .shadow(radius: 4)
                        }

                        Color.clear
                            .frame(width: 60)
                    }
                    .padding(.bottom, 48)
                }
            }
            .background(Color.black)
            .navigationTitle("iPhone Camera")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
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
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        context.coordinator.previewLayer = previewLayer

        context.coordinator.session = session
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.previewLayer?.frame = uiView.bounds
    }

    func makeCoordinator() -> Coordinator { Coordinator() }
    class Coordinator {
        var session: AVCaptureSession?
        var previewLayer: AVCaptureVideoPreviewLayer?
    }
}
