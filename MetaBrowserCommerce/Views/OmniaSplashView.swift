//
//  OmniaSplashView.swift
//  Meta Browser Commerce
//
//  "Powered by Omnia" at the beginning of the app flow
//

import SwiftUI

struct OmniaSplashView: View {
    @EnvironmentObject var appState: AppState
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Powered by Omnia")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.9))
                    .opacity(opacity)

                Image("OmniaLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 200)
                    .opacity(opacity)
            }
            .onAppear {
                withAnimation(.easeIn(duration: 0.6)) {
                    opacity = 1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    dismiss()
                }
            }
            .onTapGesture {
                dismiss()
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            appState.hasSeenOmniaSplash = true
        }
    }
}
