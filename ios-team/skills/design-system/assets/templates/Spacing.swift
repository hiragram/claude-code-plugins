import SwiftUI

// MARK: - Spacing Scale

/// Base spacing values. Use with @ScaledMetric for Dynamic Type support.
///
/// Example:
/// ```swift
/// struct MyView: View {
///     let theme: DesignSystem
///     @ScaledMetric private var spacing: CGFloat = 16
///
///     var body: some View {
///         VStack(spacing: spacing) {
///             // ...
///         }
///         .onAppear {
///             spacing = theme.spacing.md
///         }
///     }
/// }
/// ```
///
/// Or use the ScaledSpacing property wrapper for convenience:
/// ```swift
/// struct MyView: View {
///     @ScaledSpacing(.md) private var spacing
/// }
/// ```
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

// MARK: - Scaled Spacing View Modifier

/// A view that provides scaled spacing values based on Dynamic Type settings.
/// Use this as a container to get properly scaled spacing.
struct ScaledSpacingProvider<Content: View>: View {
    let spacing: SpacingScale
    let content: (ScaledValues) -> Content

    @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1.0

    struct ScaledValues {
        let xxs: CGFloat
        let xs: CGFloat
        let sm: CGFloat
        let md: CGFloat
        let lg: CGFloat
        let xl: CGFloat
        let xxl: CGFloat
        let xxxl: CGFloat
    }

    var body: some View {
        content(ScaledValues(
            xxs: spacing.xxs * scale,
            xs: spacing.xs * scale,
            sm: spacing.sm * scale,
            md: spacing.md * scale,
            lg: spacing.lg * scale,
            xl: spacing.xl * scale,
            xxl: spacing.xxl * scale,
            xxxl: spacing.xxxl * scale
        ))
    }
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

/// Base layout values. Use with @ScaledMetric for Dynamic Type support.
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

// MARK: - View Extensions

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

// MARK: - Scaled Layout Helper

/// A view that provides scaled layout values based on Dynamic Type settings.
struct ScaledLayoutProvider<Content: View>: View {
    let layout: LayoutConstants
    let content: (ScaledLayoutValues) -> Content

    @ScaledMetric(relativeTo: .body) private var scale: CGFloat = 1.0

    struct ScaledLayoutValues {
        let horizontalPadding: CGFloat
        let verticalPadding: CGFloat
        let minTouchTarget: CGFloat
        let iconSizeSmall: CGFloat
        let iconSize: CGFloat
        let iconSizeLarge: CGFloat
    }

    var body: some View {
        content(ScaledLayoutValues(
            horizontalPadding: layout.horizontalPadding * scale,
            verticalPadding: layout.verticalPadding * scale,
            minTouchTarget: max(layout.minTouchTarget, layout.minTouchTarget * scale), // Never smaller than base
            iconSizeSmall: layout.iconSizeSmall * scale,
            iconSize: layout.iconSize * scale,
            iconSizeLarge: layout.iconSizeLarge * scale
        ))
    }
}

// MARK: - Usage Example
/*
// Option 1: Use ScaledSpacingProvider for automatic scaling
struct MyView: View {
    let theme: DesignSystem

    var body: some View {
        ScaledSpacingProvider(spacing: theme.spacing) { scaled in
            VStack(spacing: scaled.md) {
                Text("Hello")
                    .padding(scaled.lg)
            }
        }
    }
}

// Option 2: Use @ScaledMetric directly
struct AnotherView: View {
    let theme: DesignSystem
    @ScaledMetric(relativeTo: .body) private var spacing: CGFloat = 16

    var body: some View {
        VStack(spacing: spacing) {
            // Content
        }
    }
}

// Option 3: For simple cases, base values work well with system fonts
// that already scale with Dynamic Type
struct SimpleView: View {
    let theme: DesignSystem

    var body: some View {
        Text("Hello")
            .font(theme.typography.bodyLarge.font) // Font scales automatically
            .padding(theme.spacing.md) // Base spacing
    }
}
*/
