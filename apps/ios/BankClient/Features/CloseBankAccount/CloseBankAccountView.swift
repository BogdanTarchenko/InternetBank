import SwiftUI

struct CloseBankAccountView: View {
    @Bindable var viewModel: CloseBankAccountViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Layout.sectionSpacing) {
                    balanceCard
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
                        .background(Appearance.destructive)
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

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: Layout.cardContentSpacing) {
            Text(Strings.balanceLabel)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(formatBalance(viewModel.bankAccount.balance, currency: viewModel.bankAccount.currency))
                .font(.system(size: Layout.balanceFontSize, weight: .semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Layout.cardPadding)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
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

    private func formatBalance(_ balance: Decimal, currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let value = NSDecimalNumber(decimal: balance)
        let string = formatter.string(from: value) ?? "\(balance)"
        return "\(string) \(currency)"
    }
}

private extension CloseBankAccountView {
    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
        static let screenVerticalPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 20
        static let cardPadding: CGFloat = 16
        static let cardContentSpacing: CGFloat = 4
        static let balanceFontSize: CGFloat = 20
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
        static let destructive = Color(red: 0.85, green: 0.35, blue: 0.25)
    }
    enum Strings {
        static let title = "Закрыть счёт"
        static let balanceLabel = "Баланс"
        static let submitButtonTitle = "Закрыть счёт"
        static let errorIconName = "exclamationmark.triangle.fill"
    }
}
