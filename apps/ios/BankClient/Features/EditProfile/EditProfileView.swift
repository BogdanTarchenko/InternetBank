import SwiftUI

struct EditProfileView: View {
    @Bindable var viewModel: EditProfileViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Layout.formSpacing) {
                    VStack(alignment: .leading, spacing: Layout.fieldLabelSpacing) {
                        Text(Strings.nameLabel)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        TextField(Strings.namePlaceholder, text: $viewModel.name)
                            .textContentType(.name)
                            .padding(.horizontal, Layout.fieldInnerHorizontal)
                            .padding(.vertical, Layout.fieldInnerVertical)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: Layout.fieldCornerRadius))
                    }
                    VStack(alignment: .leading, spacing: Layout.fieldLabelSpacing) {
                        Text(Strings.emailLabel)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                        TextField(Strings.emailPlaceholder, text: $viewModel.email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
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
                                Text(Strings.saveTitle)
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
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(Strings.cancelTitle) {
                        viewModel.dismiss()
                    }
                }
            }
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

private extension EditProfileView {
    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
        static let screenVerticalPadding: CGFloat = 16
        static let cardPadding: CGFloat = 16
        static let formSpacing: CGFloat = 16
        static let fieldLabelSpacing: CGFloat = 6
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
        static let title = "Редактировать профиль"
        static let nameLabel = "Имя"
        static let namePlaceholder = "Имя"
        static let emailLabel = "Email"
        static let emailPlaceholder = "email@example.com"
        static let saveTitle = "Сохранить"
        static let cancelTitle = "Отмена"
        static let errorIconName = "exclamationmark.triangle.fill"
    }
}
