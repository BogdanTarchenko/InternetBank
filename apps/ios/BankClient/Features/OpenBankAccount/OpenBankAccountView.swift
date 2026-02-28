import SwiftUI

struct OpenBankAccountView: View {
    @Bindable var viewModel: OpenBankAccountViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Layout.sectionSpacing) {
                    if let message = viewModel.errorMessage {
                        errorBlock(message: message)
                    }
                    Button(action: { Task { await viewModel.submit() } }) {
                        HStack {
                            if viewModel.isSubmitting {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: Strings.buttonIconName)
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
                .padding(Layout.screenHorizontalPadding)
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

private extension OpenBankAccountView {
    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
        static let screenVerticalPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 20
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
        static let title = "Открыть счёт"
        static let submitButtonTitle = "Открыть счёт"
        static let buttonIconName = "plus.circle.fill"
        static let errorIconName = "exclamationmark.triangle.fill"
    }
}
