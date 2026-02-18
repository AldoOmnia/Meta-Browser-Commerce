//
//  AppTheme.swift
//  Meta Browser Commerce
//
//  High-contrast theme for legibility and accessibility
//

import SwiftUI

enum AppTheme {
    // Backgrounds
    static let background = Color(red: 15/255, green: 15/255, blue: 17/255)
    static let cardBackground = Color(red: 28/255, green: 28/255, blue: 31/255)
    static let cardBackgroundElevated = Color(red: 38/255, green: 38/255, blue: 42/255)

    // Text - high contrast
    static let textPrimary = Color.white
    static let textSecondary = Color(white: 0.72)
    static let textTertiary = Color(white: 0.58)

    // Accent
    static let accent = Color(red: 8/255, green: 102/255, blue: 255/255)
    static let accentBackground = Color(red: 8/255, green: 102/255, blue: 255/255).opacity(0.2)
    static let success = Color(red: 52/255, green: 199/255, blue: 89/255)

    // Typography - larger for legibility
    static func title() -> Font { .title2.weight(.bold) }
    static func titleLarge() -> Font { .largeTitle.weight(.bold) }
    static func headline() -> Font { .headline }
    static func body() -> Font { .body }
    static func bodyEmphasized() -> Font { .body.weight(.semibold) }
    static func callout() -> Font { .callout }
    static func calloutSecondary() -> Font { .callout }
    static func caption() -> Font { .subheadline }
}
