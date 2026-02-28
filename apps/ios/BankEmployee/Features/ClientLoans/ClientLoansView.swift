import SwiftUI

struct ClientLoansView: View {
    @Bindable var viewModel: ClientLoansViewModel
    var createLoanViewModelFactory: ParameterizedFactory<Client, CreateLoanViewModel>
    @State private var showCreateLoan = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let message = viewModel.errorMessage {
                    errorBlock(message: message)
                        .padding(Layout.screenHorizontalPadding)
                } else if viewModel.loans.isEmpty {
                    emptyState
                } else {
                    listContent
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle(Strings.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(Strings.createLoanTitle, action: { showCreateLoan = true })
                }
            }
            .sheet(isPresented: $showCreateLoan) {
                CreateLoanView(viewModel: createLoanSheetViewModel())
            }
            .task { await viewModel.load() }
        }
    }

    private var listContent: some View {
        ScrollView {
            VStack(spacing: Layout.cardSpacing) {
                ForEach(viewModel.loans) { loan in
                    Button(action: { viewModel.loanTapped(loan) }) {
                        loanRow(loan)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Layout.screenHorizontalPadding)
            .padding(.vertical, Layout.screenVerticalPadding)
        }
    }

    private func loanRow(_ loan: Loan) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: Layout.rowContentSpacing) {
                Text(formatAmount(loan.remainingAmount) + " \(loan.currency)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(Strings.remainingLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: Strings.chevronIconName)
                .font(.system(size: Layout.chevronSize))
                .foregroundStyle(.secondary)
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

    private func createLoanSheetViewModel() -> CreateLoanViewModel {
        let vm = createLoanViewModelFactory.make(viewModel.client)
        vm.onSuccess = { showCreateLoan = false; Task { await viewModel.load() } }
        return vm
    }

    private func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "\(amount)"
    }
}

private extension ClientLoansView {
    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
        static let screenVerticalPadding: CGFloat = 16
        static let cardSpacing: CGFloat = 12
        static let cardPadding: CGFloat = 16
        static let rowContentSpacing: CGFloat = 2
        static let chevronSize: CGFloat = 14
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
        static let title = "Кредиты клиента"
        static let remainingLabel = "Остаток"
        static let chevronIconName = "chevron.right"
        static let emptyStateTitle = "Нет кредитов"
        static let emptyStateIconName = "banknote"
        static let errorIconName = "exclamationmark.triangle.fill"
        static let createLoanTitle = "Выдать кредит"
    }
}
