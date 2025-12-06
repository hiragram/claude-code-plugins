import SwiftUI

// MARK: - Typography Scale

extension Font {

    // MARK: Display

    /// Large title - 34pt Bold - Hero sections, onboarding
    static let displayLarge = Font.system(size: 34, weight: .bold, design: .default)

    /// Medium title - 28pt Bold - Section headers
    static let displayMedium = Font.system(size: 28, weight: .bold, design: .default)

    /// Small title - 22pt Bold - Card titles
    static let displaySmall = Font.system(size: 22, weight: .bold, design: .default)

    // MARK: Headline

    /// Large headline - 17pt Semibold - List item titles
    static let headlineLarge = Font.system(size: 17, weight: .semibold, design: .default)

    /// Medium headline - 15pt Semibold - Subheadings
    static let headlineMedium = Font.system(size: 15, weight: .semibold, design: .default)

    /// Small headline - 13pt Semibold - Labels
    static let headlineSmall = Font.system(size: 13, weight: .semibold, design: .default)

    // MARK: Body

    /// Large body - 17pt Regular - Primary body text
    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)

    /// Medium body - 15pt Regular - Secondary body text
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)

    /// Small body - 13pt Regular - Tertiary text, captions
    static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)

    // MARK: Caption

    /// Large caption - 12pt Regular - Supporting text
    static let captionLarge = Font.system(size: 12, weight: .regular, design: .default)

    /// Small caption - 11pt Regular - Fine print, timestamps
    static let captionSmall = Font.system(size: 11, weight: .regular, design: .default)

    // MARK: Button

    /// Large button text - 17pt Semibold
    static let buttonLarge = Font.system(size: 17, weight: .semibold, design: .default)

    /// Medium button text - 15pt Semibold
    static let buttonMedium = Font.system(size: 15, weight: .semibold, design: .default)

    /// Small button text - 13pt Medium
    static let buttonSmall = Font.system(size: 13, weight: .medium, design: .default)
}

// MARK: - Text Style Modifier

struct AppTextStyle: ViewModifier {
    let font: Font
    let color: Color
    let lineSpacing: CGFloat

    init(font: Font, color: Color = .textPrimary, lineSpacing: CGFloat = 0) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
    }

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineSpacing(lineSpacing)
    }
}

extension View {
    func textStyle(_ font: Font, color: Color = .textPrimary, lineSpacing: CGFloat = 0) -> some View {
        modifier(AppTextStyle(font: font, color: color, lineSpacing: lineSpacing))
    }
}
