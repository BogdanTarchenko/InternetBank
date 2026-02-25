import SwiftUI

struct LoginView: View {
    @Bindable var viewModel: LoginViewModel
    @FocusState private var focusedField: LoginField?

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0)
            header
            formCard
                .frame(maxWidth: Layout.formMaxWidth)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, Layout.screenHorizontalPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private var header: some View {
        VStack(spacing: Layout.headerSpacing) {
            Image(systemName: Strings.headerIconName)
                .font(.system(size: Layout.headerIconSize, weight: .medium))
                .foregroundStyle(LinearGradient.appAccent)
            Text(Strings.title)
                .font(.system(size: Layout.headerTitleSize, weight: .bold))
            Text(Strings.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, Layout.headerBottomPadding)
    }

    private var formCard: some View {
        VStack(alignment: .leading, spacing: Layout.formCardSpacing) {
            VStack(alignment: .leading, spacing: Layout.fieldBlockSpacing) {
                Text(Strings.emailLabel)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .padding(.leading, Layout.fieldLabelLeading)
                TextField(Strings.emailPlaceholder, text: $viewModel.login)
                    .textContentType(.username)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .focused($focusedField, equals: .email)
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
                    .textContentType(.password)
                    .focused($focusedField, equals: .password)
                    .padding(.horizontal, Layout.fieldInnerHorizontal)
                    .padding(.vertical, Layout.fieldInnerVertical)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Layout.fieldCornerRadius))
            }

            if let message = viewModel.errorMessage {
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
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: Layout.errorBlockCornerRadius))
            }

            Button(action: { Task { await viewModel.submit() } }) {
                HStack {
                    if viewModel.isLoading {
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
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal, Layout.cardHorizontalPadding)
        .padding(.vertical, Layout.cardVerticalPadding)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
    }
}

private extension LoginView {
    enum Layout {
        static let formMaxWidth: CGFloat = 360
        static let screenHorizontalPadding: CGFloat = 16
        static let headerSpacing: CGFloat = 8
        static let headerIconSize: CGFloat = 36
        static let headerTitleSize: CGFloat = 24
        static let headerBottomPadding: CGFloat = 24
        static let formCardSpacing: CGFloat = 20
        static let fieldBlockSpacing: CGFloat = 8
        static let fieldLabelLeading: CGFloat = 8
        static let fieldInnerHorizontal: CGFloat = 8
        static let fieldInnerVertical: CGFloat = 12
        static let fieldCornerRadius: CGFloat = 12
        static let errorBlockSpacing: CGFloat = 12
        static let errorStripCornerRadius: CGFloat = 6
        static let errorStripWidth: CGFloat = 4
        static let errorStripHeight: CGFloat = 32
        static let errorIconSize: CGFloat = 14
        static let errorBlockInnerPadding: CGFloat = 8
        static let errorBlockCornerRadius: CGFloat = 10
        static let buttonVerticalPadding: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 12
        static let cardHorizontalPadding: CGFloat = 16
        static let cardVerticalPadding: CGFloat = 24
        static let cardCornerRadius: CGFloat = 16
        static let cardShadowOpacity: Double = 0.04
        static let cardShadowRadius: CGFloat = 8
        static let cardShadowY: CGFloat = 2
    }
    enum Appearance {
        static let errorAccent = Color(red: 0.85, green: 0.35, blue: 0.25)
    }
    enum Strings {
        static let title = "Вход"
        static let subtitle = "Введите данные для входа в приложение"
        static let headerIconName = "building.columns.fill"
        static let emailLabel = "Почта"
        static let emailPlaceholder = "Email"
        static let passwordLabel = "Пароль"
        static let passwordPlaceholder = "Пароль"
        static let errorIconName = "exclamationmark.triangle.fill"
        static let submitButtonTitle = "Войти"
    }
}
