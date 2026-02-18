//
//  AnimatedPlaceholderField.swift
//  Meta Browser Commerce
//
//  Text field with fading rotating placeholder examples (no quotes).
//  Fixed size matching reference rectangle.21.15.png
//

import SwiftUI

struct AnimatedPlaceholderField: View {
    let examples = [
        "Find running shoes under $80",
        "Compare these two items and find the best match",
        "Find me a similar product and add to Amazon cart",
        "Place pickup at closest La Colombe",
        "Add Nike Air Max to cart",
    ]
    @Binding var text: String
    @State private var currentExampleIndex = 0
    @State private var placeholderOpacity: Double = 0.6

    /// Fixed size matching reference rectangle (rectangle.21.15.png)
    private let fieldWidth: CGFloat = 315
    private let fieldHeight: CGFloat = 52

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(examples[currentExampleIndex])
                    .foregroundStyle(AppTheme.textSecondary.opacity(placeholderOpacity))
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 16)
            }
            TextField("", text: $text)
                .foregroundStyle(AppTheme.textPrimary)
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
                .autocorrectionDisabled()
        }
        .frame(width: fieldWidth, height: fieldHeight)
        .onAppear {
            scheduleNextExample()
        }
    }

    private func scheduleNextExample() {
        guard text.isEmpty else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                placeholderOpacity = 0.25
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentExampleIndex = (currentExampleIndex + 1) % examples.count
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
