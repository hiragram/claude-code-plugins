import SwiftUI

// MARK: - Spacing Scale (8pt Grid)

enum Spacing {
    /// 4pt - Micro spacing for tight layouts
    static let xxs: CGFloat = 4

    /// 8pt - Extra small spacing
    static let xs: CGFloat = 8

    /// 12pt - Small spacing
    static let sm: CGFloat = 12

    /// 16pt - Medium spacing (default)
    static let md: CGFloat = 16

    /// 24pt - Large spacing
    static let lg: CGFloat = 24

    /// 32pt - Extra large spacing
    static let xl: CGFloat = 32

    /// 48pt - 2X large spacing
    static let xxl: CGFloat = 48

    /// 64pt - 3X large spacing
    static let xxxl: CGFloat = 64
}

// MARK: - Corner Radius

enum CornerRadius {
    /// 4pt - Small radius for tags, badges
    static let xs: CGFloat = 4

    /// 8pt - Medium radius for buttons, inputs
    static let sm: CGFloat = 8

    /// 12pt - Large radius for cards
    static let md: CGFloat = 12

    /// 16pt - Extra large radius for modals
    static let lg: CGFloat = 16

    /// 24pt - Full radius for pills
    static let xl: CGFloat = 24

    /// Circular - for avatars, icons
    static let full: CGFloat = .infinity
}

// MARK: - Shadow Styles

struct AppShadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    /// Small shadow - subtle elevation
    static let sm = AppShadow(
        color: Color.black.opacity(0.08),
        radius: 4,
        x: 0,
        y: 2
    )

    /// Medium shadow - card elevation
    static let md = AppShadow(
        color: Color.black.opacity(0.12),
        radius: 8,
        x: 0,
        y: 4
    )

    /// Large shadow - modal elevation
    static let lg = AppShadow(
        color: Color.black.opacity(0.16),
        radius: 16,
        x: 0,
        y: 8
    )
}

extension View {
    func appShadow(_ shadow: AppShadow) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}

// MARK: - Layout Constants

enum Layout {
    /// Standard horizontal padding for screens
    static let horizontalPadding: CGFloat = Spacing.md

    /// Standard vertical padding for screens
    static let verticalPadding: CGFloat = Spacing.md

    /// Minimum touch target size (44pt - Apple HIG)
    static let minTouchTarget: CGFloat = 44

    /// Standard icon size
    static let iconSize: CGFloat = 24

    /// Small icon size
    static let iconSizeSmall: CGFloat = 16

    /// Large icon size
    static let iconSizeLarge: CGFloat = 32
}
