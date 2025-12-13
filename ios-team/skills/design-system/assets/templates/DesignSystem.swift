import SwiftUI

// MARK: - Design System

/// A unified design system containing all style definitions
struct DesignSystem {
    let name: String
    let colors: ColorPalette
    let typography: Typography
    let spacing: SpacingScale
    let cornerRadius: CornerRadiusScale
    let shadow: ShadowScale
    let layout: LayoutConstants
}

// MARK: - Default Instance

extension DesignSystem {
    static let `default` = DesignSystem(
        name: "Default",
        colors: .default,
        typography: .default,
        spacing: .default,
        cornerRadius: .default,
        shadow: .default,
        layout: .default
    )
}

// MARK: - Example Theme Instances

extension DesignSystem {
    /// Minimal/Modern theme with sharp corners and subtle shadows
    static let minimal = DesignSystem(
        name: "Minimal",
        colors: ColorPalette(
            primaryBrand: AdaptiveColor(hex: "000000"),
            secondaryBrand: AdaptiveColor(hex: "6B6B6B"),
            backgroundPrimary: AdaptiveColor(light: "FFFFFF", dark: "0A0A0A"),
            backgroundSecondary: AdaptiveColor(light: "F8F8F8", dark: "1A1A1A"),
            backgroundTertiary: AdaptiveColor(light: "F0F0F0", dark: "2A2A2A"),
            textPrimary: AdaptiveColor(light: "000000", dark: "FFFFFF"),
            textSecondary: AdaptiveColor(light: "666666", dark: "999999"),
            textTertiary: AdaptiveColor(light: "999999", dark: "666666"),
            success: AdaptiveColor(hex: "00C853"),
            warning: AdaptiveColor(hex: "FFB300"),
            error: AdaptiveColor(hex: "FF1744"),
            info: AdaptiveColor(hex: "2979FF"),
            separator: AdaptiveColor(light: "E0E0E0", dark: "333333"),
            border: AdaptiveColor(light: "E0E0E0", dark: "333333")
        ),
        typography: .default,
        spacing: .default,
        cornerRadius: .sharp,
        shadow: .none,
        layout: .default
    )

    /// Pop/Casual theme with rounded corners and vibrant colors
    static let pop = DesignSystem(
        name: "Pop",
        colors: ColorPalette(
            primaryBrand: AdaptiveColor(hex: "FF6B6B"),
            secondaryBrand: AdaptiveColor(hex: "4ECDC4"),
            backgroundPrimary: AdaptiveColor(light: "FFFFFF", dark: "1C1C1E"),
            backgroundSecondary: AdaptiveColor(light: "FFF9F0", dark: "2C2C2E"),
            backgroundTertiary: AdaptiveColor(light: "F0F7FF", dark: "3A3A3C"),
            textPrimary: AdaptiveColor(light: "2D3436", dark: "FFFFFF"),
            textSecondary: AdaptiveColor(light: "636E72", dark: "B2BEC3"),
            textTertiary: AdaptiveColor(light: "B2BEC3", dark: "636E72"),
            success: AdaptiveColor(hex: "00B894"),
            warning: AdaptiveColor(hex: "FDCB6E"),
            error: AdaptiveColor(hex: "E17055"),
            info: AdaptiveColor(hex: "74B9FF"),
            separator: AdaptiveColor(light: "DFE6E9", dark: "4A4A4A"),
            border: AdaptiveColor(light: "DFE6E9", dark: "4A4A4A")
        ),
        typography: .rounded,
        spacing: .default,
        cornerRadius: .rounded,
        shadow: .default,
        layout: .default
    )
}

// MARK: - Preview

private struct DesignSystemPreview: View {
    let theme: DesignSystem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Theme Name
                Text(theme.name)
                    .font(theme.typography.displayLarge.font)
                    .foregroundColor(theme.colors.textPrimary.color)

                // Colors Section
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Colors")
                        .font(theme.typography.headlineLarge.font)
                        .foregroundColor(theme.colors.textPrimary.color)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: theme.spacing.sm) {
                        ColorSwatch(adaptiveColor: theme.colors.primaryBrand, label: "Primary")
                        ColorSwatch(adaptiveColor: theme.colors.secondaryBrand, label: "Secondary")
                        ColorSwatch(adaptiveColor: theme.colors.success, label: "Success")
                        ColorSwatch(adaptiveColor: theme.colors.warning, label: "Warning")
                        ColorSwatch(adaptiveColor: theme.colors.error, label: "Error")
                    }

                    Text("Backgrounds")
                        .font(theme.typography.headlineSmall.font)
                        .foregroundColor(theme.colors.textSecondary.color)
                        .padding(.top, theme.spacing.xs)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: theme.spacing.sm) {
                        ColorSwatch(adaptiveColor: theme.colors.backgroundPrimary, label: "BG Primary", showBorder: true)
                        ColorSwatch(adaptiveColor: theme.colors.backgroundSecondary, label: "BG Secondary", showBorder: true)
                        ColorSwatch(adaptiveColor: theme.colors.backgroundTertiary, label: "BG Tertiary", showBorder: true)
                    }
                }

                // Typography Section
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    Text("Typography")
                        .font(theme.typography.headlineLarge.font)
                        .foregroundColor(theme.colors.textPrimary.color)

                    TypographySample(label: "Display Large", style: theme.typography.displayLarge, sampleText: "日本語表示", textColor: theme.colors.textPrimary.color)
                    TypographySample(label: "Headline Large", style: theme.typography.headlineLarge, sampleText: "見出し", textColor: theme.colors.textPrimary.color)
                    TypographySample(label: "Body Large", style: theme.typography.bodyLarge, sampleText: "本文テキスト", textColor: theme.colors.textSecondary.color)
                    TypographySample(label: "Caption Small", style: theme.typography.captionSmall, sampleText: "キャプション", textColor: theme.colors.textTertiary.color)
                }

                // Buttons Section
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Buttons")
                        .font(theme.typography.headlineLarge.font)
                        .foregroundColor(theme.colors.textPrimary.color)

                    Button("Primary Button") {}
                        .buttonStyle(PrimaryButtonStyle(theme: theme))

                    Button("Secondary Button") {}
                        .buttonStyle(SecondaryButtonStyle(theme: theme))
                }

                // Corner Radius Section
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Corner Radius")
                        .font(theme.typography.headlineLarge.font)
                        .foregroundColor(theme.colors.textPrimary.color)

                    HStack(spacing: theme.spacing.md) {
                        RoundedRectangle(cornerRadius: theme.cornerRadius.xs)
                            .fill(theme.colors.primaryBrand.color)
                            .frame(width: 50, height: 50)
                        RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                            .fill(theme.colors.primaryBrand.color)
                            .frame(width: 50, height: 50)
                        RoundedRectangle(cornerRadius: theme.cornerRadius.md)
                            .fill(theme.colors.primaryBrand.color)
                            .frame(width: 50, height: 50)
                        RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                            .fill(theme.colors.primaryBrand.color)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .padding(theme.spacing.lg)
        }
        .background(theme.colors.backgroundPrimary.color)
    }
}

private struct ColorSwatch: View {
    let adaptiveColor: AdaptiveColor
    let label: String
    var showBorder: Bool = false

    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8)
                .fill(adaptiveColor.color)
                .frame(width: 60, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(showBorder ? 0.3 : 0), lineWidth: 1)
                )
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(adaptiveColor.hex)
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .foregroundColor(.secondary)
        }
    }
}

private struct TypographySample: View {
    let label: String
    let style: FontStyle
    let sampleText: String
    let textColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(label) \(sampleText)")
                .font(style.font)
                .foregroundColor(textColor)
            Text(style.description)
                .font(.system(size: 11, weight: .regular, design: .monospaced))
                .foregroundColor(.secondary)
        }
    }
}

struct DesignSystem_Previews: PreviewProvider {
    static var themes: [DesignSystem] = [.default, .minimal, .pop]

    static var previews: some View {
        ForEach(themes, id: \.name) { theme in
            DesignSystemPreview(theme: theme)
                .previewDisplayName(theme.name)
        }
    }
}
