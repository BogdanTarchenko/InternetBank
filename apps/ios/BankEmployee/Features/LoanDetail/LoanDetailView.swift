import SwiftUI

struct LoanDetailView: View {
    @Bindable var viewModel: LoanDetailViewModel

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.tariffName == nil && viewModel.loan.tariffId != nil {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let message = viewModel.errorMessage {
                    errorBlock(message: message)
                        .padding(Layout.screenHorizontalPadding)
                } else {
                    detailContent
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle(Strings.title)
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.load() }
        }
    }

    private var detailContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Layout.cardSpacing) {
                row(Strings.totalLabel, formatAmount(viewModel.loan.totalAmount) + " \(viewModel.loan.currency)")
                row(Strings.remainingLabel, formatAmount(viewModel.loan.remainingAmount) + " \(viewModel.loan.currency)")
                row(Strings.currencyLabel, viewModel.loan.currency)
                if let name = viewModel.tariffName {
                    row(Strings.tariffLabel, name)
                }
                row(Strings.dateLabel, formatDate(viewModel.loan.createdAt))
            }
            .padding(Layout.screenHorizontalPadding)
            .padding(.vertical, Layout.screenVerticalPadding)
        }
    }

    private func row(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: Layout.rowContentSpacing) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
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

    private func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "\(amount)"
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

private extension LoanDetailView {
    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
        static let screenVerticalPadding: CGFloat = 16
        static let cardSpacing: CGFloat = 12
        static let cardPadding: CGFloat = 16
        static let rowContentSpacing: CGFloat = 4
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
    }
    enum Appearance {
        static let errorAccent = Color(red: 0.85, green: 0.35, blue: 0.25)
    }
    enum Strings {
        static let title = "Кредит"
        static let totalLabel = "Сумма кредита"
        static let remainingLabel = "Остаток"
        static let currencyLabel = "Валюта"
        static let tariffLabel = "Тариф"
        static let dateLabel = "Дата оформления"
        static let errorIconName = "exclamationmark.triangle.fill"
    }
}
