import SwiftUI

struct BankAccountListView: View {
    @Bindable var viewModel: BankAccountListViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            accountsTab
                .tabItem {
                    Label(Strings.accountsTabTitle, systemImage: Strings.accountsTabIconName)
                }
                .tag(0)
            loansTab
                .tabItem {
                    Label(Strings.loansTabTitle, systemImage: Strings.loansTabIconName)
                }
                .tag(1)
        }
        .tabViewStyle(.automatic)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
        .task { await viewModel.load() }
    }

    private var accountsTab: some View {
        tabContent(
            title: Strings.accountsTabTitle,
            subtitle: Strings.accountsTabSubtitle,
            iconName: Strings.accountsTabIconName,
            isLoading: viewModel.isLoading && viewModel.accounts.isEmpty,
            errorMessage: viewModel.errorMessage,
            itemCount: viewModel.accounts.count,
            listContent: {
                if viewModel.accounts.isEmpty {
                    emptyAccountsState
                } else {
                    ForEach(viewModel.accounts) { account in
                        accountCard(account)
                    }
                }
            },
            actionButton: { openAccountButton },
            actionButtonPadding: Layout.buttonBottomPadding
        )
    }

    private var loansTab: some View {
        tabContent(
            title: Strings.loansTabTitle,
            subtitle: Strings.loansTabSubtitle,
            iconName: Strings.loansTabIconName,
            isLoading: viewModel.isLoading && viewModel.loans.isEmpty,
            errorMessage: viewModel.errorMessage,
            itemCount: viewModel.loans.count,
            listContent: {
                if viewModel.loans.isEmpty {
                    emptyLoansState
                } else {
                    ForEach(viewModel.loans) { loan in
                        loanCard(loan)
                    }
                }
            },
            actionButton: { takeLoanButton },
            actionButtonPadding: Layout.buttonBottomPadding
        )
    }

    private func tabContent<Content: View, Action: View>(
        title: String,
        subtitle: String,
        iconName: String,
        isLoading: Bool,
        errorMessage: String?,
        itemCount: Int,
        @ViewBuilder listContent: () -> Content,
        @ViewBuilder actionButton: () -> Action,
        actionButtonPadding: CGFloat
    ) -> some View {
        VStack(spacing: 0) {
            tabHeader(title: title, subtitle: subtitle, iconName: iconName)

            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let message = errorMessage {
                errorBlock(message: message)
                    .padding(.horizontal, Layout.screenHorizontalPadding)
                Spacer(minLength: 0)
            } else if itemCount == 0 {
                ScrollView {
                    VStack(spacing: Layout.cardSpacing) {
                        listContent()
                        actionButton()
                            .padding(.top, Layout.sectionSpacing)
                    }
                    .padding(.horizontal, Layout.screenHorizontalPadding)
                    .padding(.bottom, actionButtonPadding)
                }
                .scrollIndicators(.hidden)
            } else {
                ScrollView {
                    VStack(spacing: Layout.cardSpacing) {
                        listContent()
                    }
                    .padding(.horizontal, Layout.screenHorizontalPadding)
                }
                .frame(maxHeight: .infinity)
                .scrollIndicators(.hidden)
                actionButton()
                    .padding(.horizontal, Layout.screenHorizontalPadding)
                    .padding(.top, Layout.sectionSpacing)
                    .padding(.bottom, actionButtonPadding)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func tabHeader(title: String, subtitle: String, iconName: String) -> some View {
        VStack(spacing: Layout.headerSpacing) {
            Image(systemName: iconName)
                .font(.system(size: Layout.headerIconSize, weight: .medium))
                .foregroundStyle(LinearGradient.appAccent)
            Text(title)
                .font(.system(size: Layout.headerTitleSize, weight: .bold))
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, Layout.headerBottomPadding)
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

    private var emptyAccountsState: some View {
        VStack(spacing: Layout.emptyStateSpacing) {
            Image(systemName: Strings.emptyStateIconName)
                .font(.system(size: Layout.emptyStateIconSize))
                .foregroundStyle(.secondary)
            Text(Strings.emptyStateTitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(Layout.emptyStatePadding)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
    }

    private var emptyLoansState: some View {
        Text(Strings.loansEmptyTitle)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding(Layout.emptyStatePadding)
            .background(Color(uiColor: .systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
            .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
    }

    private func accountCard(_ account: BankAccount) -> some View {
        VStack(alignment: .leading, spacing: Layout.accountCardInnerSpacing) {
            HStack {
                VStack(alignment: .leading, spacing: Layout.cardContentSpacing) {
                    Text(Strings.balanceLabel)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(formatBalance(account.balance, currency: account.currency))
                        .font(.system(size: Layout.balanceFontSize, weight: .semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: { viewModel.closeBankAccountTapped(bankAccount: account) }) {
                    Image(systemName: Strings.closeAccountIconName)
                        .font(.system(size: Layout.closeIconSize))
                        .foregroundStyle(Appearance.errorAccent)
                }
            }
            HStack(spacing: Layout.actionButtonSpacing) {
                Button(action: { viewModel.depositTapped(bankAccount: account) }) {
                    Label(Strings.depositButtonTitle, systemImage: Strings.depositButtonIconName)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Layout.actionButtonVerticalPadding)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: Layout.actionButtonCornerRadius))
                }
                .buttonStyle(.plain)
                Button(action: { viewModel.withdrawTapped(bankAccount: account) }) {
                    Label(Strings.withdrawButtonTitle, systemImage: Strings.withdrawButtonIconName)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Layout.actionButtonVerticalPadding)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: Layout.actionButtonCornerRadius))
                }
                .buttonStyle(.plain)
                Button(action: { viewModel.transactionHistoryTapped(bankAccount: account) }) {
                    Label(Strings.historyButtonTitle, systemImage: Strings.historyButtonIconName)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Layout.actionButtonVerticalPadding)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: Layout.actionButtonCornerRadius))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(Layout.cardPadding)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
    }

    private func loanCard(_ loan: Loan) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: Layout.cardContentSpacing) {
                Text(Strings.loanRemainingLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(formatBalance(loan.remainingAmount, currency: loan.currency))
                    .font(.system(size: Layout.balanceFontSize, weight: .semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: { viewModel.repayLoanTapped(loan: loan) }) {
                Text(Strings.repayLoanButtonTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(.horizontal, Layout.repayButtonHorizontalPadding)
                    .padding(.vertical, Layout.actionButtonVerticalPadding)
                    .background(LinearGradient.appAccent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.actionButtonCornerRadius))
            }
            .buttonStyle(.plain)
        }
        .padding(Layout.cardPadding)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
    }

    private var openAccountButton: some View {
        Button(action: { viewModel.openBankAccountTapped() }) {
            HStack {
                if viewModel.isLoading && !viewModel.accounts.isEmpty {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: Strings.openAccountButtonIconName)
                    Text(Strings.openAccountButtonTitle)
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

    private var takeLoanButton: some View {
        Button(action: { viewModel.takeLoanTapped() }) {
            HStack {
                Image(systemName: Strings.takeLoanButtonIconName)
                Text(Strings.takeLoanButtonTitle)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Layout.buttonVerticalPadding)
            .background(LinearGradient.appAccent)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: Layout.buttonCornerRadius))
        }
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

private extension BankAccountListView {
    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
        static let screenVerticalPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 20
        static let headerSpacing: CGFloat = 8
        static let headerIconSize: CGFloat = 36
        static let headerTitleSize: CGFloat = 24
        static let headerBottomPadding: CGFloat = 24
        static let errorBlockSpacing: CGFloat = 12
        static let errorStripCornerRadius: CGFloat = 6
        static let errorStripWidth: CGFloat = 4
        static let errorStripHeight: CGFloat = 32
        static let errorIconSize: CGFloat = 14
        static let errorBlockInnerPadding: CGFloat = 8
        static let errorBlockVerticalPadding: CGFloat = 12
        static let errorBlockCornerRadius: CGFloat = 10
        static let cardSpacing: CGFloat = 12
        static let cardPadding: CGFloat = 16
        static let cardContentSpacing: CGFloat = 4
        static let balanceFontSize: CGFloat = 20
        static let closeIconSize: CGFloat = 20
        static let cardCornerRadius: CGFloat = 16
        static let cardShadowOpacity: Double = 0.04
        static let cardShadowRadius: CGFloat = 8
        static let cardShadowY: CGFloat = 2
        static let emptyStateSpacing: CGFloat = 8
        static let emptyStateIconSize: CGFloat = 44
        static let emptyStatePadding: CGFloat = 32
        static let buttonVerticalPadding: CGFloat = 16
        static let buttonBottomPadding: CGFloat = 24
        static let buttonCornerRadius: CGFloat = 12
        static let accountCardInnerSpacing: CGFloat = 12
        static let actionButtonSpacing: CGFloat = 8
        static let actionButtonVerticalPadding: CGFloat = 10
        static let actionButtonCornerRadius: CGFloat = 10
        static let repayButtonHorizontalPadding: CGFloat = 16
    }
    enum Appearance {
        static let errorAccent = Color(red: 0.85, green: 0.35, blue: 0.25)
    }
    enum Strings {
        static let accountsTabTitle = "Мои счета"
        static let accountsTabSubtitle = "Управление счетами"
        static let accountsTabIconName = "creditcard.fill"
        static let loansTabTitle = "Мои кредиты"
        static let loansTabSubtitle = "Управление кредитами"
        static let loansTabIconName = "banknote"
        static let balanceLabel = "Баланс"
        static let closeAccountIconName = "xmark.circle.fill"
        static let errorIconName = "exclamationmark.triangle.fill"
        static let emptyStateTitle = "Нет открытых счетов.\nНажмите кнопку ниже, чтобы открыть счёт."
        static let emptyStateIconName = "creditcard"
        static let openAccountButtonTitle = "Открыть счёт"
        static let openAccountButtonIconName = "plus.circle.fill"
        static let depositButtonTitle = "Внести"
        static let depositButtonIconName = "arrow.down.circle"
        static let withdrawButtonTitle = "Снять"
        static let withdrawButtonIconName = "arrow.up.circle"
        static let historyButtonTitle = "История"
        static let historyButtonIconName = "list.bullet"
        static let loansEmptyTitle = "Нет активных кредитов"
        static let loanRemainingLabel = "Остаток"
        static let repayLoanButtonTitle = "Погасить"
        static let takeLoanButtonTitle = "Взять кредит"
        static let takeLoanButtonIconName = "banknote"
    }
}
