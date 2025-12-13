import SwiftUI

// MARK: - Font Style (with metadata)

struct FontStyle {
    let baseSize: CGFloat
    let weight: Font.Weight
    let design: Font.Design
    let textStyle: Font.TextStyle

    init(size: CGFloat, weight: Font.Weight, design: Font.Design = .default, relativeTo textStyle: Font.TextStyle = .body) {
        self.baseSize = size
        self.weight = weight
        self.design = design
        self.textStyle = textStyle
    }

    /// Font that scales with Dynamic Type
    var font: Font {
        .system(size: baseSize, weight: weight, design: design)
            .leading(.standard)
    }

    /// For use with @ScaledMetric in views
    var size: CGFloat { baseSize }

    var weightName: String {
        switch weight {
        case .ultraLight: return "UltraLight"
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "Semibold"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        case .black: return "Black"
        default: return "Regular"
        }
    }

    var designName: String {
        switch design {
        case .default: return "Default"
        case .rounded: return "Rounded"
        case .serif: return "Serif"
        case .monospaced: return "Mono"
        @unknown default: return "Default"
        }
    }

    var description: String {
        "\(designName) \(weightName) \(Int(baseSize))pt"
    }
}

// MARK: - Typography

struct Typography {
    // Display
    let displayLarge: FontStyle
    let displayMedium: FontStyle
    let displaySmall: FontStyle

    // Headline
    let headlineLarge: FontStyle
    let headlineMedium: FontStyle
    let headlineSmall: FontStyle

    // Body
    let bodyLarge: FontStyle
    let bodyMedium: FontStyle
    let bodySmall: FontStyle

    // Caption
    let captionLarge: FontStyle
    let captionSmall: FontStyle

    // Button
    let buttonLarge: FontStyle
    let buttonMedium: FontStyle
    let buttonSmall: FontStyle
}

// MARK: - Default Instance

extension Typography {
    static let `default` = Typography(
        // Display
        displayLarge: FontStyle(size: 34, weight: .bold, relativeTo: .largeTitle),
        displayMedium: FontStyle(size: 28, weight: .bold, relativeTo: .title),
        displaySmall: FontStyle(size: 22, weight: .bold, relativeTo: .title2),

        // Headline
        headlineLarge: FontStyle(size: 17, weight: .semibold, relativeTo: .headline),
        headlineMedium: FontStyle(size: 15, weight: .semibold, relativeTo: .subheadline),
        headlineSmall: FontStyle(size: 13, weight: .semibold, relativeTo: .footnote),

        // Body
        bodyLarge: FontStyle(size: 17, weight: .regular, relativeTo: .body),
        bodyMedium: FontStyle(size: 15, weight: .regular, relativeTo: .subheadline),
        bodySmall: FontStyle(size: 13, weight: .regular, relativeTo: .footnote),

        // Caption
        captionLarge: FontStyle(size: 12, weight: .regular, relativeTo: .caption),
        captionSmall: FontStyle(size: 11, weight: .regular, relativeTo: .caption2),

        // Button
        buttonLarge: FontStyle(size: 17, weight: .semibold, relativeTo: .body),
        buttonMedium: FontStyle(size: 15, weight: .semibold, relativeTo: .subheadline),
        buttonSmall: FontStyle(size: 13, weight: .medium, relativeTo: .footnote)
    )

    /// Rounded variant - friendly, casual feel
    static let rounded = Typography(
        displayLarge: FontStyle(size: 34, weight: .bold, design: .rounded, relativeTo: .largeTitle),
        displayMedium: FontStyle(size: 28, weight: .bold, design: .rounded, relativeTo: .title),
        displaySmall: FontStyle(size: 22, weight: .bold, design: .rounded, relativeTo: .title2),
        headlineLarge: FontStyle(size: 17, weight: .semibold, design: .rounded, relativeTo: .headline),
        headlineMedium: FontStyle(size: 15, weight: .semibold, design: .rounded, relativeTo: .subheadline),
        headlineSmall: FontStyle(size: 13, weight: .semibold, design: .rounded, relativeTo: .footnote),
        bodyLarge: FontStyle(size: 17, weight: .regular, design: .rounded, relativeTo: .body),
        bodyMedium: FontStyle(size: 15, weight: .regular, design: .rounded, relativeTo: .subheadline),
        bodySmall: FontStyle(size: 13, weight: .regular, design: .rounded, relativeTo: .footnote),
        captionLarge: FontStyle(size: 12, weight: .regular, design: .rounded, relativeTo: .caption),
        captionSmall: FontStyle(size: 11, weight: .regular, design: .rounded, relativeTo: .caption2),
        buttonLarge: FontStyle(size: 17, weight: .semibold, design: .rounded, relativeTo: .body),
        buttonMedium: FontStyle(size: 15, weight: .semibold, design: .rounded, relativeTo: .subheadline),
        buttonSmall: FontStyle(size: 13, weight: .medium, design: .rounded, relativeTo: .footnote)
    )
}
