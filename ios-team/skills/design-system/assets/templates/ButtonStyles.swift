import SwiftUI

// MARK: - Themed Button Styles

/// Button styles that accept a DesignSystem for theming
struct ThemedButtonStyles {
    let theme: DesignSystem

    var primary: PrimaryButtonStyle {
        PrimaryButtonStyle(theme: theme)
    }

    var secondary: SecondaryButtonStyle {
        SecondaryButtonStyle(theme: theme)
    }

    var tertiary: TertiaryButtonStyle {
        TertiaryButtonStyle(theme: theme)
    }

    var destructive: DestructiveButtonStyle {
        DestructiveButtonStyle(theme: theme)
    }
}

// MARK: - Primary Button Style

struct PrimaryButtonStyle: ButtonStyle {
    let theme: DesignSystem
    @Environment(\.isEnabled) private var isEnabled

    init(theme: DesignSystem = .default) {
        self.theme = theme
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.typography.buttonLarge)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                    .fill(isEnabled ? theme.colors.primaryBrand : theme.colors.primaryBrand.opacity(0.5))
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Secondary Button Style

struct SecondaryButtonStyle: ButtonStyle {
    let theme: DesignSystem
    @Environment(\.isEnabled) private var isEnabled

    init(theme: DesignSystem = .default) {
        self.theme = theme
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.typography.buttonLarge)
            .foregroundColor(isEnabled ? theme.colors.primaryBrand : theme.colors.primaryBrand.opacity(0.5))
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                    .stroke(isEnabled ? theme.colors.primaryBrand : theme.colors.primaryBrand.opacity(0.5), lineWidth: 1.5)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Tertiary Button Style

struct TertiaryButtonStyle: ButtonStyle {
    let theme: DesignSystem
    @Environment(\.isEnabled) private var isEnabled

    init(theme: DesignSystem = .default) {
        self.theme = theme
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.typography.buttonMedium)
            .foregroundColor(isEnabled ? theme.colors.primaryBrand : theme.colors.primaryBrand.opacity(0.5))
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Destructive Button Style

struct DestructiveButtonStyle: ButtonStyle {
    let theme: DesignSystem
    @Environment(\.isEnabled) private var isEnabled

    init(theme: DesignSystem = .default) {
        self.theme = theme
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.typography.buttonLarge)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                    .fill(isEnabled ? theme.colors.error : theme.colors.error.opacity(0.5))
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Usage Example
/*
let theme = DesignSystem.default
let buttons = ThemedButtonStyles(theme: theme)

// Using themed button styles
Button("Primary Action") {
    // action
}
.buttonStyle(buttons.primary)

Button("Secondary Action") {
    // action
}
.buttonStyle(buttons.secondary)

Button("Learn More") {
    // action
}
.buttonStyle(buttons.tertiary)

Button("Delete") {
    // action
}
.buttonStyle(buttons.destructive)

// Or directly with theme
Button("Action") {
    // action
}
.buttonStyle(PrimaryButtonStyle(theme: .pop))
*/
