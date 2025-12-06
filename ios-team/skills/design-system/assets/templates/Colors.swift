import SwiftUI

// MARK: - Color Palette

struct ColorPalette {
    // Brand
    let primaryBrand: Color
    let secondaryBrand: Color

    // Background
    let backgroundPrimary: Color
    let backgroundSecondary: Color
    let backgroundTertiary: Color

    // Text
    let textPrimary: Color
    let textSecondary: Color
    let textTertiary: Color

    // Semantic
    let success: Color
    let warning: Color
    let error: Color
    let info: Color

    // Border & Separator
    let separator: Color
    let border: Color
}

// MARK: - Default Instance

extension ColorPalette {
    static let `default` = ColorPalette(
        // Brand
        primaryBrand: Color(hex: "007AFF"),
        secondaryBrand: Color(hex: "5856D6"),

        // Background
        backgroundPrimary: Color(light: .white, dark: Color(hex: "1C1C1E")),
        backgroundSecondary: Color(light: Color(hex: "F2F2F7"), dark: Color(hex: "2C2C2E")),
        backgroundTertiary: Color(light: Color(hex: "FFFFFF"), dark: Color(hex: "3A3A3C")),

        // Text
        textPrimary: Color(light: Color(hex: "000000"), dark: Color(hex: "FFFFFF")),
        textSecondary: Color(light: Color(hex: "3C3C43").opacity(0.6), dark: Color(hex: "EBEBF5").opacity(0.6)),
        textTertiary: Color(light: Color(hex: "3C3C43").opacity(0.3), dark: Color(hex: "EBEBF5").opacity(0.3)),

        // Semantic
        success: Color(hex: "34C759"),
        warning: Color(hex: "FF9500"),
        error: Color(hex: "FF3B30"),
        info: Color(hex: "007AFF"),

        // Border & Separator
        separator: Color(light: Color(hex: "3C3C43").opacity(0.3), dark: Color(hex: "545458").opacity(0.6)),
        border: Color(light: Color(hex: "C6C6C8"), dark: Color(hex: "545458"))
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
