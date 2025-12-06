import SwiftUI

// MARK: - Spacing Scale

struct SpacingScale {
    let xxs: CGFloat  // Micro spacing
    let xs: CGFloat   // Extra small
    let sm: CGFloat   // Small
    let md: CGFloat   // Medium (default)
    let lg: CGFloat   // Large
    let xl: CGFloat   // Extra large
    let xxl: CGFloat  // 2X large
    let xxxl: CGFloat // 3X large
}

extension SpacingScale {
    /// 8pt grid system
    static let `default` = SpacingScale(
        xxs: 4,
        xs: 8,
        sm: 12,
        md: 16,
        lg: 24,
        xl: 32,
        xxl: 48,
        xxxl: 64
    )

    /// Compact spacing for dense UIs
    static let compact = SpacingScale(
        xxs: 2,
        xs: 4,
        sm: 8,
        md: 12,
        lg: 16,
        xl: 24,
        xxl: 32,
        xxxl: 48
    )
}

// MARK: - Corner Radius Scale

struct CornerRadiusScale {
    let xs: CGFloat   // Tags, badges
    let sm: CGFloat   // Buttons, inputs
    let md: CGFloat   // Cards
    let lg: CGFloat   // Modals
    let xl: CGFloat   // Pills
    let full: CGFloat // Circular
}

extension CornerRadiusScale {
    static let `default` = CornerRadiusScale(
        xs: 4,
        sm: 8,
        md: 12,
        lg: 16,
        xl: 24,
        full: .infinity
    )

    /// Sharp corners for minimal/modern style
    static let sharp = CornerRadiusScale(
        xs: 0,
        sm: 2,
        md: 4,
        lg: 6,
        xl: 8,
        full: .infinity
    )

    /// Rounded corners for friendly/soft style
    static let rounded = CornerRadiusScale(
        xs: 8,
        sm: 12,
        md: 16,
        lg: 20,
        xl: 28,
        full: .infinity
    )
}

// MARK: - Shadow Scale

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

struct ShadowScale {
    let sm: ShadowStyle  // Subtle elevation
    let md: ShadowStyle  // Card elevation
    let lg: ShadowStyle  // Modal elevation
}

extension ShadowScale {
    static let `default` = ShadowScale(
        sm: ShadowStyle(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2),
        md: ShadowStyle(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4),
        lg: ShadowStyle(color: Color.black.opacity(0.16), radius: 16, x: 0, y: 8)
    )

    /// No shadows for flat design
    static let none = ShadowScale(
        sm: ShadowStyle(color: .clear, radius: 0, x: 0, y: 0),
        md: ShadowStyle(color: .clear, radius: 0, x: 0, y: 0),
        lg: ShadowStyle(color: .clear, radius: 0, x: 0, y: 0)
    )
}

// MARK: - Layout Constants

struct LayoutConstants {
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let minTouchTarget: CGFloat
    let iconSizeSmall: CGFloat
    let iconSize: CGFloat
    let iconSizeLarge: CGFloat
}

extension LayoutConstants {
    static let `default` = LayoutConstants(
        horizontalPadding: 16,
        verticalPadding: 16,
        minTouchTarget: 44,
        iconSizeSmall: 16,
        iconSize: 24,
        iconSizeLarge: 32
    )
}

// MARK: - View Extension

extension View {
    func shadow(_ style: ShadowStyle) -> some View {
        self.shadow(
            color: style.color,
            radius: style.radius,
            x: style.x,
            y: style.y
        )
    }
}
