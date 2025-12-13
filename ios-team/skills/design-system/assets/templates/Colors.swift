import SwiftUI

// MARK: - Adaptive Color (light/dark hex pair)

struct AdaptiveColor {
    let lightHex: String
    let darkHex: String

    var color: Color {
        Color(light: Color(hex: lightHex), dark: Color(hex: darkHex))
    }

    var hex: String { "#\(lightHex.uppercased())" }

    init(light: String, dark: String) {
        self.lightHex = light
        self.darkHex = dark
    }

    init(hex: String) {
        self.lightHex = hex
        self.darkHex = hex
    }
}

// MARK: - Color Palette

struct ColorPalette {
    // Brand
    let primaryBrand: AdaptiveColor
    let secondaryBrand: AdaptiveColor

    // Background
    let backgroundPrimary: AdaptiveColor
    let backgroundSecondary: AdaptiveColor
    let backgroundTertiary: AdaptiveColor

    // Text
    let textPrimary: AdaptiveColor
    let textSecondary: AdaptiveColor
    let textTertiary: AdaptiveColor

    // Semantic
    let success: AdaptiveColor
    let warning: AdaptiveColor
    let error: AdaptiveColor
    let info: AdaptiveColor

    // Border & Separator
    let separator: AdaptiveColor
    let border: AdaptiveColor
}

// MARK: - Default Instance

extension ColorPalette {
    static let `default` = ColorPalette(
        // Brand
        primaryBrand: AdaptiveColor(hex: "007AFF"),
        secondaryBrand: AdaptiveColor(hex: "5856D6"),

        // Background
        backgroundPrimary: AdaptiveColor(light: "FFFFFF", dark: "1C1C1E"),
        backgroundSecondary: AdaptiveColor(light: "F2F2F7", dark: "2C2C2E"),
        backgroundTertiary: AdaptiveColor(light: "FFFFFF", dark: "3A3A3C"),

        // Text
        textPrimary: AdaptiveColor(light: "000000", dark: "FFFFFF"),
        textSecondary: AdaptiveColor(light: "3C3C43", dark: "EBEBF5"),
        textTertiary: AdaptiveColor(light: "3C3C43", dark: "EBEBF5"),

        // Semantic
        success: AdaptiveColor(hex: "34C759"),
        warning: AdaptiveColor(hex: "FF9500"),
        error: AdaptiveColor(hex: "FF3B30"),
        info: AdaptiveColor(hex: "007AFF"),

        // Border & Separator
        separator: AdaptiveColor(light: "3C3C43", dark: "545458"),
        border: AdaptiveColor(light: "C6C6C8", dark: "545458")
    )
}

// MARK: - Color Utilities

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}
