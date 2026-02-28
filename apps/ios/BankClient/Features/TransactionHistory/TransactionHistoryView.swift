import SwiftUI

struct TransactionHistoryView: View {
    @Bindable var viewModel: TransactionHistoryViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let message = viewModel.errorMessage {
                    errorBlock(message: message)
                        .padding(Layout.screenHorizontalPadding)
                } else if viewModel.transactions.isEmpty {
                    emptyState
                } else {
                    listContent
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle(Strings.title)
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.load() }
        }
    }

    private var listContent: some View {
        ScrollView {
            VStack(spacing: Layout.cardSpacing) {
                ForEach(viewModel.transactions) { transaction in
                    transactionRow(transaction)
                }
            }
            .padding(Layout.screenHorizontalPadding)
            .padding(.vertical, Layout.screenVerticalPadding)
        }
    }

    private func transactionRow(_ transaction: Transaction) -> some View {
        HStack {
            Image(systemName: transaction.type == .deposit ? Strings.depositIconName : Strings.withdrawIconName)
                .font(.system(size: Layout.iconSize))
                .foregroundStyle(transaction.type == .deposit ? Color.green : Appearance.errorAccent)
                .frame(width: Layout.iconSize + 8, alignment: .center)
            VStack(alignment: .leading, spacing: Layout.rowContentSpacing) {
                Text(transaction.type == .deposit ? Strings.depositTitle : Strings.withdrawTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(formatDate(transaction.date))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text((transaction.type == .deposit ? "+" : "−") + formatAmount(transaction.amount) + " \(viewModel.bankAccount.currency)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(transaction.type == .deposit ? Color.green : Color.primary)
        }
        .padding(Layout.cardPadding)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
    }

    private var emptyState: some View {
        VStack(spacing: Layout.emptyStateSpacing) {
            Image(systemName: Strings.emptyStateIconName)
                .font(.system(size: Layout.emptyStateIconSize))
                .foregroundStyle(.secondary)
            Text(Strings.emptyStateTitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

    private func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "\(amount)"
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

private extension TransactionHistoryView {
    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
        static let screenVerticalPadding: CGFloat = 16
        static let cardSpacing: CGFloat = 12
        static let cardPadding: CGFloat = 16
        static let rowContentSpacing: CGFloat = 2
        static let iconSize: CGFloat = 20
        static let cardCornerRadius: CGFloat = 16
        static let cardShadowOpacity: Double = 0.04
        static let cardShadowRadius: CGFloat = 8
        static let cardShadowY: CGFloat = 2
        static let emptyStateSpacing: CGFloat = 8
        static let emptyStateIconSize: CGFloat = 44
        static let errorBlockSpacing: CGFloat = 12
        static let errorStripCornerRadius: CGFloat = 6
        static let errorStripWidth: CGFloat = 4
        static let errorStripHeight: CGFloat = 32
        static let errorIconSize: CGFloat = 14
        static let errorBlockInnerPadding: CGFloat = 8
        static let errorBlockVerticalPadding: CGFloat = 12
        static let errorBlockCornerRadius: CGFloat = 10
    }
    enum Appearance {
        static let errorAccent = Color(red: 0.85, green: 0.35, blue: 0.25)
    }
    enum Strings {
        static let title = "История операций"
        static let depositIconName = "arrow.down.circle.fill"
        static let withdrawIconName = "arrow.up.circle.fill"
        static let depositTitle = "Пополнение"
        static let withdrawTitle = "Снятие"
        static let emptyStateTitle = "Нет операций"
        static let emptyStateIconName = "list.bullet"
        static let errorIconName = "exclamationmark.triangle.fill"
    }
}
