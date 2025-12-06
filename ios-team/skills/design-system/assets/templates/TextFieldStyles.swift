import SwiftUI

// MARK: - App Text Field Style

struct AppTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    let isError: Bool

    init(isError: Bool = false) {
        self.isError = isError
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.bodyLarge)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(Color.backgroundTertiary)
            .cornerRadius(CornerRadius.sm)
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.sm)
                    .stroke(borderColor, lineWidth: 1)
            )
    }

    private var borderColor: Color {
        if isError {
            return .error
        }
        return .border
    }
}

// MARK: - Labeled Text Field

struct LabeledTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var errorMessage: String?
    var isSecure: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .font(.headlineSmall)
                .foregroundColor(.textSecondary)

            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(AppTextFieldStyle(isError: errorMessage != nil))
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(AppTextFieldStyle(isError: errorMessage != nil))
            }

            if let error = errorMessage {
                Text(error)
                    .font(.captionLarge)
                    .foregroundColor(.error)
            }
        }
    }
}

// MARK: - Search Field Style

struct SearchFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
                .frame(width: Layout.iconSize, height: Layout.iconSize)

            configuration
                .font(.bodyMedium)
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xs)
        .background(Color.backgroundSecondary)
        .cornerRadius(CornerRadius.sm)
    }
}

// MARK: - Usage Example
/*
// Basic text field
TextField("Enter name", text: $name)
    .textFieldStyle(AppTextFieldStyle())

// With error state
TextField("Enter email", text: $email)
    .textFieldStyle(AppTextFieldStyle(isError: true))

// Labeled text field
LabeledTextField(
    label: "Email",
    placeholder: "your@email.com",
    text: $email,
    errorMessage: emailError
)

// Password field
LabeledTextField(
    label: "Password",
    placeholder: "Enter password",
    text: $password,
    isSecure: true
)

// Search field
TextField("Search...", text: $searchText)
    .textFieldStyle(SearchFieldStyle())
*/
