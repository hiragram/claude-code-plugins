import SwiftUI

// MARK: - Semantic Colors

extension Color {

    // MARK: Brand Colors

    /// Primary brand color - used for main CTAs, links, and key UI elements
    static let primaryBrand = Color(hex: "007AFF")

    /// Secondary brand color - used for secondary actions and accents
    static let secondaryBrand = Color(hex: "5856D6")

    // MARK: Background Colors

    /// Primary background - main screen backgrounds
    static let backgroundPrimary = Color(light: .white, dark: Color(hex: "1C1C1E"))

    /// Secondary background - cards, grouped content
    static let backgroundSecondary = Color(light: Color(hex: "F2F2F7"), dark: Color(hex: "2C2C2E"))

    /// Tertiary background - nested content, input fields
    static let backgroundTertiary = Color(light: Color(hex: "FFFFFF"), dark: Color(hex: "3A3A3C"))

    // MARK: Text Colors

    /// Primary text - headings, body text
    static let textPrimary = Color(light: Color(hex: "000000"), dark: Color(hex: "FFFFFF"))

    /// Secondary text - subtitles, captions
    static let textSecondary = Color(light: Color(hex: "3C3C43").opacity(0.6), dark: Color(hex: "EBEBF5").opacity(0.6))

    /// Tertiary text - placeholders, disabled text
    static let textTertiary = Color(light: Color(hex: "3C3C43").opacity(0.3), dark: Color(hex: "EBEBF5").opacity(0.3))

    // MARK: Semantic Colors

    /// Success state - confirmations, completed actions
    static let success = Color(hex: "34C759")

    /// Warning state - alerts requiring attention
    static let warning = Color(hex: "FF9500")

    /// Error state - errors, destructive actions
    static let error = Color(hex: "FF3B30")

    /// Info state - informational messages
    static let info = Color(hex: "007AFF")

    // MARK: Border & Separator

    /// Separator color for dividers
    static let separator = Color(light: Color(hex: "3C3C43").opacity(0.3), dark: Color(hex: "545458").opacity(0.6))

    /// Border color for input fields and cards
    static let border = Color(light: Color(hex: "C6C6C8"), dark: Color(hex: "545458"))
}

// MARK: - Color Utilities

extension Color {

    /// Initialize color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
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

    /// Create adaptive color for light/dark mode
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
