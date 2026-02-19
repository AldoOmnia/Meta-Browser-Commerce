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
    var povImageName: String? = nil
}

struct VoiceCommandCardView: View {
    @Binding var text: String
    var onSendToGlasses: (String) -> Void

    /// Only prompts with POV images — others moved to action cards
    let examples: [VoiceCommandExample] = [
        VoiceCommandExample(id: "1", prompt: "Find me a similar product on Amazon", povIcon: "cart.badge.plus", povImageName: "AddToCart"),
        VoiceCommandExample(id: "2", prompt: "Help me find a sofa that fits my living room", povIcon: "camera.metering.center.weighted", povImageName: "Sofa"),
        VoiceCommandExample(id: "3", prompt: "Help me compare these two items and find the best reviews online", povIcon: "rectangle.on.rectangle.angled", povImageName: "Compare"),
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
            // POV view: large 1:1 image with "Glasses POV" overlay top-right
            ZStack(alignment: .topTrailing) {
                if let imgName = currentExample.povImageName {
                    Image(imgName)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxHeight: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Text("Glasses POV")
                    .font(.caption2)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6))
                    .padding(8)
            }
            .frame(height: 240)

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
        .frame(minWidth: minWidthForLongestPrompt, maxWidth: .infinity, minHeight: 320)
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
