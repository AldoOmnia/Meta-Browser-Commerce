//
//  VoiceCommandCardView.swift
//  Meta Browser Commerce
//
//  Intuitive voice command UI: large rounded rectangle sized for longest prompt,
//  mock POV views, cycling examples. Send to glasses CTA.
//

import SwiftUI

struct VoiceCommandExample: Identifiable {
    let id: String
    let prompt: String
    let povIcon: String
}

struct VoiceCommandCardView: View {
    @Binding var text: String
    var onSendToGlasses: (String) -> Void

    let examples: [VoiceCommandExample] = [
        VoiceCommandExample(id: "1", prompt: "Find running shoes under $80", povIcon: "figure.run"),
        VoiceCommandExample(id: "2", prompt: "Compare these two items and find the best match online", povIcon: "rectangle.on.rectangle.angled"),
        VoiceCommandExample(id: "3", prompt: "Find me a similar product and add it to Amazon cart", povIcon: "cart.badge.plus"),
        VoiceCommandExample(id: "4", prompt: "Place pickup at closest La Colombe", povIcon: "cup.and.saucer.fill"),
        VoiceCommandExample(id: "5", prompt: "Order from Starbucks", povIcon: "cup.and.saucer.fill"),
        VoiceCommandExample(id: "6", prompt: "Add Nike Air Max to cart", povIcon: "tag.fill"),
        VoiceCommandExample(id: "7", prompt: "Help me find options for a sofa that fits my living room", povIcon: "camera.metering.center.weighted"),
    ]

    @State private var currentIndex = 0
    @State private var placeholderOpacity: Double = 0.6

    /// Width to fit the longest prompt — rectangle stays this large even for short text
    private var minWidthForLongestPrompt: CGFloat {
        let font = UIFont.systemFont(ofSize: 17)
        let padding: CGFloat = 48
        let longest = examples.map(\.prompt).max(by: { $0.count < $1.count }) ?? examples[0].prompt
        let size = (longest as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 60),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return min(size.width + padding, 380)
    }

    private var currentExample: VoiceCommandExample {
        examples[currentIndex]
    }

    private var commandToSend: String {
        text.isEmpty ? currentExample.prompt : text
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Voice commands rectangle (full width)
            voiceCommandRectangle

            // Send to glasses CTA (full width, below)
            sendToGlassesButton
        }
    }

    private var voiceCommandRectangle: some View {
        VStack(spacing: 0) {
            // Mock POV view for current command
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppTheme.cardBackgroundElevated)
                    .aspectRatio(16/9, contentMode: .fit)

                Image("Glasses")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 36)
                    .opacity(0.4)

                Image(systemName: currentExample.povIcon)
                    .font(.title2)
                    .foregroundStyle(AppTheme.accent.opacity(0.6))
            }
            .frame(height: 72)

            // Voice command text (cycling examples or custom)
            ZStack(alignment: .leading) {
                TextField("", text: $text)
                    .foregroundStyle(AppTheme.textPrimary)
                    .lineLimit(2)
                    .font(.body)
                    .autocorrectionDisabled()

                if text.isEmpty {
                    Text("\"\(currentExample.prompt)\"")
                        .foregroundStyle(AppTheme.textSecondary.opacity(placeholderOpacity))
                        .lineLimit(2)
                        .font(.body)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .allowsHitTesting(false)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .frame(minWidth: minWidthForLongestPrompt, maxWidth: .infinity, minHeight: 160)
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onAppear {
            scheduleNextExample()
        }
    }

    private var sendToGlassesButton: some View {
        Button {
            onSendToGlasses(commandToSend)
        } label: {
            HStack(spacing: 12) {
                Image("WhiteGlasses")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                Text("Send to Glasses")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(AppTheme.accent)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private func scheduleNextExample() {
        guard text.isEmpty else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                placeholderOpacity = 0.25
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentIndex = (currentIndex + 1) % examples.count
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    placeholderOpacity = 0.6
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                scheduleNextExample()
            }
        }
    }
}
