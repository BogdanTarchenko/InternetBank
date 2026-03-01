import SwiftUI

struct RegisterView: View {
    @Bindable var viewModel: RegisterViewModel
    @FocusState private var focusedField: RegisterField?

    var body: some View {
        NavigationStack {
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
            .navigationTitle(Strings.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Strings.backButtonTitle) {
                        viewModel.dismiss()
                    }
                }
            }
        }
    }

    private var header: some View {
        VStack(spacing: Layout.headerSpacing) {
            Image(systemName: Strings.headerIconName)
                .font(.system(size: Layout.headerIconSize, weight: .medium))
                .foregroundStyle(LinearGradient.appAccent)
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
                Text(Strings.nameLabel)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .padding(.leading, Layout.fieldLabelLeading)
                TextField(Strings.namePlaceholder, text: $viewModel.name)
                    .textContentType(.name)
                    .focused($focusedField, equals: .name)
                    .padding(.horizontal, Layout.fieldInnerHorizontal)
                    .padding(.vertical, Layout.fieldInnerVertical)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Layout.fieldCornerRadius))
            }

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
                    .textContentType(.newPassword)
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

enum RegisterField {
    case name
    case email
    case password
}

private extension RegisterView {
    enum Layout {
        static let formMaxWidth: CGFloat = 360
        static let screenHorizontalPadding: CGFloat = 16
        static let headerSpacing: CGFloat = 8
        static let headerIconSize: CGFloat = 36
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
        static let title = "Регистрация"
        static let subtitle = "Создайте аккаунт для входа в приложение"
        static let headerIconName = "person.crop.circle.badge.plus"
        static let nameLabel = "Имя"
        static let namePlaceholder = "Имя"
        static let emailLabel = "Почта"
        static let emailPlaceholder = "Email"
        static let passwordLabel = "Пароль"
        static let passwordPlaceholder = "Пароль"
        static let errorIconName = "exclamationmark.triangle.fill"
        static let submitButtonTitle = "Зарегистрироваться"
        static let backButtonTitle = "Назад"
    }
}
