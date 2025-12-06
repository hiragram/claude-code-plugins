import SwiftUI

// MARK: - Typography

struct Typography {
    // Display
    let displayLarge: Font
    let displayMedium: Font
    let displaySmall: Font

    // Headline
    let headlineLarge: Font
    let headlineMedium: Font
    let headlineSmall: Font

    // Body
    let bodyLarge: Font
    let bodyMedium: Font
    let bodySmall: Font

    // Caption
    let captionLarge: Font
    let captionSmall: Font

    // Button
    let buttonLarge: Font
    let buttonMedium: Font
    let buttonSmall: Font
}

// MARK: - Default Instance

extension Typography {
    static let `default` = Typography(
        // Display
        displayLarge: .system(size: 34, weight: .bold, design: .default),
        displayMedium: .system(size: 28, weight: .bold, design: .default),
        displaySmall: .system(size: 22, weight: .bold, design: .default),

        // Headline
        headlineLarge: .system(size: 17, weight: .semibold, design: .default),
        headlineMedium: .system(size: 15, weight: .semibold, design: .default),
        headlineSmall: .system(size: 13, weight: .semibold, design: .default),

        // Body
        bodyLarge: .system(size: 17, weight: .regular, design: .default),
        bodyMedium: .system(size: 15, weight: .regular, design: .default),
        bodySmall: .system(size: 13, weight: .regular, design: .default),

        // Caption
        captionLarge: .system(size: 12, weight: .regular, design: .default),
        captionSmall: .system(size: 11, weight: .regular, design: .default),

        // Button
        buttonLarge: .system(size: 17, weight: .semibold, design: .default),
        buttonMedium: .system(size: 15, weight: .semibold, design: .default),
        buttonSmall: .system(size: 13, weight: .medium, design: .default)
    )

    /// Rounded variant - friendly, casual feel
    static let rounded = Typography(
        displayLarge: .system(size: 34, weight: .bold, design: .rounded),
        displayMedium: .system(size: 28, weight: .bold, design: .rounded),
        displaySmall: .system(size: 22, weight: .bold, design: .rounded),
        headlineLarge: .system(size: 17, weight: .semibold, design: .rounded),
        headlineMedium: .system(size: 15, weight: .semibold, design: .rounded),
        headlineSmall: .system(size: 13, weight: .semibold, design: .rounded),
        bodyLarge: .system(size: 17, weight: .regular, design: .rounded),
        bodyMedium: .system(size: 15, weight: .regular, design: .rounded),
        bodySmall: .system(size: 13, weight: .regular, design: .rounded),
        captionLarge: .system(size: 12, weight: .regular, design: .rounded),
        captionSmall: .system(size: 11, weight: .regular, design: .rounded),
        buttonLarge: .system(size: 17, weight: .semibold, design: .rounded),
        buttonMedium: .system(size: 15, weight: .semibold, design: .rounded),
        buttonSmall: .system(size: 13, weight: .medium, design: .rounded)
    )
}
