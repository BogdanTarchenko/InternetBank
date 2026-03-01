import SwiftUI

struct ProfileView: View {
    @Bindable var viewModel: ProfileViewModel

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: Layout.sectionSpacing) {
                        profileCard
                        if let message = viewModel.errorMessage {
                            errorBlock(message: message)
                        }
                        logoutButton
                    }
                    .padding(.horizontal, Layout.screenHorizontalPadding)
                    .padding(.vertical, Layout.screenVerticalPadding)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
        .task { await viewModel.load() }
    }

    private var profileCard: some View {
        VStack(alignment: .leading, spacing: Layout.cardContentSpacing) {
            HStack(spacing: Layout.headerSpacing) {
                Image(systemName: Strings.avatarIconName)
                    .font(.system(size: Layout.avatarSize))
                    .foregroundStyle(LinearGradient.appAccent)
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.name.isEmpty ? Strings.noName : viewModel.name)
                        .font(.headline)
                    Text(viewModel.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: { viewModel.editTapped() }) {
                    Image(systemName: Strings.editIconName)
                        .font(.system(size: Layout.editIconSize))
                        .foregroundStyle(LinearGradient.appAccent)
                }
            }
            .padding(Layout.cardPadding)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
    }

    private var logoutButton: some View {
        Button(action: { viewModel.logout() }) {
            HStack {
                Image(systemName: Strings.logoutIconName)
                Text(Strings.logoutTitle)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Layout.buttonVerticalPadding)
            .foregroundStyle(Appearance.logoutAccent)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: Layout.buttonCornerRadius))
        }
        .buttonStyle(.plain)
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

private extension ProfileView {
    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
        static let screenVerticalPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 20
        static let cardPadding: CGFloat = 16
        static let cardContentSpacing: CGFloat = 4
        static let headerSpacing: CGFloat = 16
        static let avatarSize: CGFloat = 48
        static let editIconSize: CGFloat = 22
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
        static let logoutAccent = Color(red: 0.85, green: 0.35, blue: 0.25)
    }
    enum Strings {
        static let avatarIconName = "person.circle.fill"
        static let logoutIconName = "rectangle.portrait.and.arrow.right"
        static let logoutTitle = "Выйти"
        static let errorIconName = "exclamationmark.triangle.fill"
        static let noName = "Пользователь"
        static let editIconName = "pencil.circle.fill"
    }
}
