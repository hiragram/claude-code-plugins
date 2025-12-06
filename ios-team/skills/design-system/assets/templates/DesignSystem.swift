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
            primaryBrand: Color(hex: "000000"),
            secondaryBrand: Color(hex: "6B6B6B"),
            backgroundPrimary: Color(light: .white, dark: Color(hex: "0A0A0A")),
            backgroundSecondary: Color(light: Color(hex: "F8F8F8"), dark: Color(hex: "1A1A1A")),
            backgroundTertiary: Color(light: Color(hex: "F0F0F0"), dark: Color(hex: "2A2A2A")),
            textPrimary: Color(light: Color(hex: "000000"), dark: Color(hex: "FFFFFF")),
            textSecondary: Color(light: Color(hex: "666666"), dark: Color(hex: "999999")),
            textTertiary: Color(light: Color(hex: "999999"), dark: Color(hex: "666666")),
            success: Color(hex: "00C853"),
            warning: Color(hex: "FFB300"),
            error: Color(hex: "FF1744"),
            info: Color(hex: "2979FF"),
            separator: Color(light: Color(hex: "E0E0E0"), dark: Color(hex: "333333")),
            border: Color(light: Color(hex: "E0E0E0"), dark: Color(hex: "333333"))
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
            primaryBrand: Color(hex: "FF6B6B"),
            secondaryBrand: Color(hex: "4ECDC4"),
            backgroundPrimary: Color(light: .white, dark: Color(hex: "1C1C1E")),
            backgroundSecondary: Color(light: Color(hex: "FFF9F0"), dark: Color(hex: "2C2C2E")),
            backgroundTertiary: Color(light: Color(hex: "F0F7FF"), dark: Color(hex: "3A3A3C")),
            textPrimary: Color(light: Color(hex: "2D3436"), dark: Color(hex: "FFFFFF")),
            textSecondary: Color(light: Color(hex: "636E72"), dark: Color(hex: "B2BEC3")),
            textTertiary: Color(light: Color(hex: "B2BEC3"), dark: Color(hex: "636E72")),
            success: Color(hex: "00B894"),
            warning: Color(hex: "FDCB6E"),
            error: Color(hex: "E17055"),
            info: Color(hex: "74B9FF"),
            separator: Color(light: Color(hex: "DFE6E9"), dark: Color(hex: "4A4A4A")),
            border: Color(light: Color(hex: "DFE6E9"), dark: Color(hex: "4A4A4A"))
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
                    .font(theme.typography.displayLarge)
                    .foregroundColor(theme.colors.textPrimary)

                // Colors Section
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Colors")
                        .font(theme.typography.headlineLarge)
                        .foregroundColor(theme.colors.textPrimary)

                    HStack(spacing: theme.spacing.xs) {
                        ColorSwatch(color: theme.colors.primaryBrand, label: "Primary")
                        ColorSwatch(color: theme.colors.secondaryBrand, label: "Secondary")
                        ColorSwatch(color: theme.colors.success, label: "Success")
                        ColorSwatch(color: theme.colors.warning, label: "Warning")
                        ColorSwatch(color: theme.colors.error, label: "Error")
                    }
                }

                // Typography Section
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Typography")
                        .font(theme.typography.headlineLarge)
                        .foregroundColor(theme.colors.textPrimary)

                    Text("Display Large")
                        .font(theme.typography.displayLarge)
                        .foregroundColor(theme.colors.textPrimary)
                    Text("Headline Large")
                        .font(theme.typography.headlineLarge)
                        .foregroundColor(theme.colors.textPrimary)
                    Text("Body Large")
                        .font(theme.typography.bodyLarge)
                        .foregroundColor(theme.colors.textSecondary)
                    Text("Caption Small")
                        .font(theme.typography.captionSmall)
                        .foregroundColor(theme.colors.textTertiary)
                }

                // Buttons Section
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Buttons")
                        .font(theme.typography.headlineLarge)
                        .foregroundColor(theme.colors.textPrimary)

                    Button("Primary Button") {}
                        .buttonStyle(PrimaryButtonStyle(theme: theme))

                    Button("Secondary Button") {}
                        .buttonStyle(SecondaryButtonStyle(theme: theme))
                }

                // Corner Radius Section
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Corner Radius")
                        .font(theme.typography.headlineLarge)
                        .foregroundColor(theme.colors.textPrimary)

                    HStack(spacing: theme.spacing.md) {
                        RoundedRectangle(cornerRadius: theme.cornerRadius.xs)
                            .fill(theme.colors.primaryBrand)
                            .frame(width: 50, height: 50)
                        RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                            .fill(theme.colors.primaryBrand)
                            .frame(width: 50, height: 50)
                        RoundedRectangle(cornerRadius: theme.cornerRadius.md)
                            .fill(theme.colors.primaryBrand)
                            .frame(width: 50, height: 50)
                        RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                            .fill(theme.colors.primaryBrand)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .padding(theme.spacing.lg)
        }
        .background(theme.colors.backgroundPrimary)
    }
}

private struct ColorSwatch: View {
    let color: Color
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 50, height: 50)
            Text(label)
                .font(.caption2)
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
