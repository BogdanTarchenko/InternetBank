import SwiftUI

struct CreateClientView: View {
    @Bindable var viewModel: CreateClientViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Layout.formSpacing) {
                    VStack(alignment: .leading, spacing: Layout.fieldBlockSpacing) {
                        Text(Strings.loginLabel)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .padding(.leading, Layout.fieldLabelLeading)
                        TextField(Strings.loginPlaceholder, text: $viewModel.login)
                            .textContentType(.username)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding(.horizontal, Layout.fieldInnerHorizontal)
                            .padding(.vertical, Layout.fieldInnerVertical)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: Layout.fieldCornerRadius))
                    }
                    VStack(alignment: .leading, spacing: Layout.fieldBlockSpacing) {
                        Text(Strings.passwordLabel)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .padding(.leading, Layout.fieldLabelLeading)
                        SecureField(Strings.passwordPlaceholder, text: $viewModel.password)
                            .textContentType(.newPassword)
                            .padding(.horizontal, Layout.fieldInnerHorizontal)
                            .padding(.vertical, Layout.fieldInnerVertical)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: Layout.fieldCornerRadius))
                    }
                    VStack(alignment: .leading, spacing: Layout.fieldBlockSpacing) {
                        Text(Strings.displayNameLabel)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                            .padding(.leading, Layout.fieldLabelLeading)
                        TextField(Strings.displayNamePlaceholder, text: $viewModel.displayName)
                            .padding(.horizontal, Layout.fieldInnerHorizontal)
                            .padding(.vertical, Layout.fieldInnerVertical)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: Layout.fieldCornerRadius))
                    }

                    if let message = viewModel.errorMessage {
                        errorBlock(message: message)
                    }

                    Button(action: { Task { await viewModel.submit() } }) {
                        HStack {
                            if viewModel.isSubmitting {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(Strings.submitButtonTitle)
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Layout.buttonVerticalPadding)
                        .background(LinearGradient.appAccent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: Layout.buttonCornerRadius))
                    }
                    .disabled(viewModel.isSubmitting)
                }
                .padding(Layout.cardPadding)
                .background(Color(uiColor: .systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
                .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
                .padding(.horizontal, Layout.screenHorizontalPadding)
                .padding(.vertical, Layout.screenVerticalPadding)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle(Strings.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func errorBlock(message: String) -> some View {
        HStack(alignment: .center, spacing: Layout.errorBlockSpacing) {
            RoundedRectangle(cornerRadius: Layout.errorStripCornerRadius)
                .fill(Appearance.errorAccent)
                .frame(width: Layout.errorStripWidth, height: Layout.errorStripHeight)
            Image(systemName: Strings.errorIconName)
                .font(.system(size: Layout.errorIconSize))
                .foregroundStyle(Appearance.errorAccent)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, Layout.errorBlockInnerPadding)
        .padding(.vertical, Layout.errorBlockVerticalPadding)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.errorBlockCornerRadius))
    }
}

private extension CreateClientView {
    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
        static let screenVerticalPadding: CGFloat = 16
        static let cardPadding: CGFloat = 16
        static let formSpacing: CGFloat = 16
        static let fieldBlockSpacing: CGFloat = 8
        static let fieldLabelLeading: CGFloat = 8
        static let fieldInnerHorizontal: CGFloat = 8
        static let fieldInnerVertical: CGFloat = 12
        static let fieldCornerRadius: CGFloat = 12
        static let cardCornerRadius: CGFloat = 16
        static let cardShadowOpacity: Double = 0.04
        static let cardShadowRadius: CGFloat = 8
        static let cardShadowY: CGFloat = 2
        static let errorBlockSpacing: CGFloat = 12
        static let errorStripCornerRadius: CGFloat = 6
        static let errorStripWidth: CGFloat = 4
        static let errorStripHeight: CGFloat = 32
        static let errorIconSize: CGFloat = 14
        static let errorBlockInnerPadding: CGFloat = 8
        static let errorBlockVerticalPadding: CGFloat = 12
        static let errorBlockCornerRadius: CGFloat = 10
        static let buttonVerticalPadding: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 12
    }
    enum Appearance {
        static let errorAccent = Color(red: 0.85, green: 0.35, blue: 0.25)
    }
    enum Strings {
        static let title = "Новый клиент"
        static let loginLabel = "Почта (логин)"
        static let loginPlaceholder = "Email"
        static let passwordLabel = "Пароль"
        static let passwordPlaceholder = "Пароль"
        static let displayNameLabel = "Имя (необязательно)"
        static let displayNamePlaceholder = "Имя"
        static let submitButtonTitle = "Создать"
        static let errorIconName = "exclamationmark.triangle.fill"
    }
}
