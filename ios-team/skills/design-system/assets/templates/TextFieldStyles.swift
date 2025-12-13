import SwiftUI

// MARK: - Themed Text Field Style

struct ThemedTextFieldStyle: TextFieldStyle {
    let theme: DesignSystem
    let isError: Bool

    init(theme: DesignSystem = .default, isError: Bool = false) {
        self.theme = theme
        self.isError = isError
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(theme.typography.bodyLarge.font)
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.sm)
            .background(theme.colors.backgroundTertiary.color)
            .cornerRadius(theme.cornerRadius.sm)
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                    .stroke(borderColor, lineWidth: 1)
            )
    }

    private var borderColor: Color {
        isError ? theme.colors.error.color : theme.colors.border.color
    }
}

// MARK: - Themed Labeled Text Field

struct ThemedLabeledTextField: View {
    let theme: DesignSystem
    let label: String
    let placeholder: String
    @Binding var text: String
    var errorMessage: String?
    var isSecure: Bool = false

    init(
        theme: DesignSystem = .default,
        label: String,
        placeholder: String,
        text: Binding<String>,
        errorMessage: String? = nil,
        isSecure: Bool = false
    ) {
        self.theme = theme
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.errorMessage = errorMessage
        self.isSecure = isSecure
    }

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            Text(label)
                .font(theme.typography.headlineSmall.font)
                .foregroundColor(theme.colors.textSecondary.color)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(ThemedTextFieldStyle(theme: theme, isError: errorMessage != nil))
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(ThemedTextFieldStyle(theme: theme, isError: errorMessage != nil))
            }

            if let error = errorMessage {
                Text(error)
                    .font(theme.typography.captionLarge.font)
                    .foregroundColor(theme.colors.error.color)
            }
        }
    }
}

// MARK: - Themed Search Field Style

struct ThemedSearchFieldStyle: TextFieldStyle {
    let theme: DesignSystem

    init(theme: DesignSystem = .default) {
        self.theme = theme
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(spacing: theme.spacing.xs) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.colors.textSecondary.color)
                .frame(width: theme.layout.iconSize, height: theme.layout.iconSize)

            configuration
                .font(theme.typography.bodyMedium.font)
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.vertical, theme.spacing.xs)
        .background(theme.colors.backgroundSecondary.color)
        .cornerRadius(theme.cornerRadius.sm)
    }
}

// MARK: - Usage Example
/*
let theme = DesignSystem.default

// Basic text field
TextField("Enter name", text: $name)
    .textFieldStyle(ThemedTextFieldStyle(theme: theme))

// With error state
TextField("Enter email", text: $email)
    .textFieldStyle(ThemedTextFieldStyle(theme: theme, isError: true))

// Labeled text field
ThemedLabeledTextField(
    theme: theme,
    label: "Email",
    placeholder: "your@email.com",
    text: $email,
    errorMessage: emailError
)

// Password field
ThemedLabeledTextField(
    theme: theme,
    label: "Password",
    placeholder: "Enter password",
    text: $password,
    isSecure: true
)

// Search field
TextField("Search...", text: $searchText)
    .textFieldStyle(ThemedSearchFieldStyle(theme: theme))

// With different theme
TextField("Name", text: $name)
    .textFieldStyle(ThemedTextFieldStyle(theme: .pop))
*/
