import SwiftUI

struct MainListView: View {
    @Bindable var viewModel: MainListViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            accountsTab
                .tabItem {
                    Label(Strings.accountsTabTitle, systemImage: Strings.accountsTabIconName)
                }
                .tag(0)
            clientsTab
                .tabItem {
                    Label(Strings.clientsTabTitle, systemImage: Strings.clientsTabIconName)
                }
                .tag(1)
            tariffsTab
                .tabItem {
                    Label(Strings.tariffsTabTitle, systemImage: Strings.tariffsTabIconName)
                }
                .tag(2)
            employeesTab
                .tabItem {
                    Label(Strings.employeesTabTitle, systemImage: Strings.employeesTabIconName)
                }
                .tag(3)
        }
        .tabViewStyle(.automatic)
        .tint(Color.appAccent)
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
                ForEach(viewModel.accounts) { account in
                    accountCard(account)
                }
            },
            actionButton: { EmptyView() },
            actionButtonPadding: Layout.buttonBottomPadding
        )
    }

    private var clientsTab: some View {
        tabContent(
            title: Strings.clientsTabTitle,
            subtitle: Strings.clientsTabSubtitle,
            iconName: Strings.clientsTabIconName,
            isLoading: viewModel.isLoading && viewModel.clients.isEmpty,
            errorMessage: viewModel.errorMessage,
            itemCount: viewModel.clients.count,
            listContent: {
                ForEach(viewModel.clients) { client in
                    clientCard(client)
                }
            },
            actionButton: { createClientButton },
            actionButtonPadding: Layout.buttonBottomPadding
        )
    }

    private var tariffsTab: some View {
        tabContent(
            title: Strings.tariffsTabTitle,
            subtitle: Strings.tariffsTabSubtitle,
            iconName: Strings.tariffsTabIconName,
            isLoading: viewModel.isLoading && viewModel.tariffs.isEmpty,
            errorMessage: viewModel.errorMessage,
            itemCount: viewModel.tariffs.count,
            listContent: {
                ForEach(viewModel.tariffs) { tariff in
                    tariffCard(tariff)
                }
            },
            actionButton: { createTariffButton },
            actionButtonPadding: Layout.buttonBottomPadding
        )
    }

    private var employeesTab: some View {
        tabContent(
            title: Strings.employeesTabTitle,
            subtitle: Strings.employeesTabSubtitle,
            iconName: Strings.employeesTabIconName,
            isLoading: viewModel.isLoading && viewModel.employees.isEmpty,
            errorMessage: viewModel.errorMessage,
            itemCount: viewModel.employees.count,
            listContent: {
                ForEach(viewModel.employees) { user in
                    employeeCard(user)
                }
            },
            actionButton: { createEmployeeButton },
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

    private func accountCard(_ account: BankAccount) -> some View {
        VStack(alignment: .leading, spacing: Layout.cardInnerSpacing) {
            HStack {
                VStack(alignment: .leading, spacing: Layout.cardContentSpacing) {
                    Text(viewModel.clientDisplayName(for: account.clientId))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(formatBalance(account.balance, currency: account.currency))
                        .font(.system(size: Layout.balanceFontSize, weight: .semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: { viewModel.transactionHistoryTapped(account: account) }) {
                    HStack(spacing: 6) {
                        Image(systemName: Strings.historyButtonIconName)
                        Text(Strings.historyButtonTitle)
                    }
                    .font(.subheadline)
                    .padding(.horizontal, Layout.actionButtonHorizontalPadding)
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

    private func clientCard(_ client: Client) -> some View {
        VStack(alignment: .leading, spacing: Layout.cardInnerSpacing) {
            HStack {
                VStack(alignment: .leading, spacing: Layout.cardContentSpacing) {
                    Text(client.displayName.isEmpty ? client.login : client.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(client.login)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if client.isBlocked {
                    Text(Strings.blockedBadge)
                        .font(.caption)
                        .foregroundStyle(Appearance.errorAccent)
                }
                Button(action: { viewModel.clientTapped(client) }) {
                    HStack(spacing: 6) {
                        Image(systemName: Strings.loansButtonIconName)
                        Text(Strings.loansButtonTitle)
                    }
                    .font(.subheadline)
                    .padding(.horizontal, Layout.actionButtonHorizontalPadding)
                    .padding(.vertical, Layout.actionButtonVerticalPadding)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Layout.actionButtonCornerRadius))
                }
                .buttonStyle(.plain)
                Button(action: { Task { await (client.isBlocked ? viewModel.unblockClient(client) : viewModel.blockClient(client)) } }) {
                    Group {
                        if viewModel.isBlockingClientId == client.id {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: client.isBlocked ? Strings.unblockIconName : Strings.blockIconName)
                                .font(.system(size: Layout.closeIconSize))
                                .foregroundStyle(Appearance.errorAccent)
                        }
                    }
                }
                .disabled(viewModel.isBlockingClientId == client.id)
            }
        }
        .padding(Layout.cardPadding)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
    }

    private func tariffCard(_ tariff: LoanTariff) -> some View {
        VStack(alignment: .leading, spacing: Layout.cardContentSpacing) {
            Text(tariff.name)
                .font(.subheadline)
                .fontWeight(.medium)
            Text(Strings.rateLabel + " \(formatRate(tariff.rate))%")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Layout.cardPadding)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
    }

    private func employeeCard(_ user: User) -> some View {
        VStack(alignment: .leading, spacing: Layout.cardInnerSpacing) {
            HStack {
                VStack(alignment: .leading, spacing: Layout.cardContentSpacing) {
                    Text(user.displayName.isEmpty ? user.login : user.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(user.login)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if user.isBlocked {
                    Text(Strings.blockedBadge)
                        .font(.caption)
                        .foregroundStyle(Appearance.errorAccent)
                }
                Button(action: { Task { await (user.isBlocked ? viewModel.unblockEmployee(user) : viewModel.blockEmployee(user)) } }) {
                    Group {
                        if viewModel.isBlockingEmployeeId == user.id {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: user.isBlocked ? Strings.unblockIconName : Strings.blockIconName)
                                .font(.system(size: Layout.closeIconSize))
                                .foregroundStyle(Appearance.errorAccent)
                        }
                    }
                }
                .disabled(viewModel.isBlockingEmployeeId == user.id)
            }
        }
        .padding(Layout.cardPadding)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
        .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
    }

    private var createTariffButton: some View {
        Button(action: { viewModel.createTariffTapped() }) {
            HStack {
                Image(systemName: Strings.createTariffButtonIconName)
                Text(Strings.createTariffButtonTitle)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Layout.buttonVerticalPadding)
            .background(LinearGradient.appAccent)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: Layout.buttonCornerRadius))
        }
    }

    private var createClientButton: some View {
        Button(action: { viewModel.createClientTapped() }) {
            HStack {
                Image(systemName: Strings.createClientButtonIconName)
                Text(Strings.createClientButtonTitle)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Layout.buttonVerticalPadding)
            .background(LinearGradient.appAccent)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: Layout.buttonCornerRadius))
        }
    }

    private var createEmployeeButton: some View {
        Button(action: { viewModel.createEmployeeTapped() }) {
            HStack {
                Image(systemName: Strings.createEmployeeButtonIconName)
                Text(Strings.createEmployeeButtonTitle)
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

    private func formatRate(_ rate: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(decimal: rate)) ?? "\(rate)"
    }
}

private extension MainListView {
    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
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
        static let cardInnerSpacing: CGFloat = 12
        static let cardContentSpacing: CGFloat = 4
        static let balanceFontSize: CGFloat = 20
        static let closeIconSize: CGFloat = 20
        static let cardCornerRadius: CGFloat = 16
        static let cardShadowOpacity: Double = 0.04
        static let cardShadowRadius: CGFloat = 8
        static let cardShadowY: CGFloat = 2
        static let buttonVerticalPadding: CGFloat = 16
        static let buttonBottomPadding: CGFloat = 24
        static let buttonCornerRadius: CGFloat = 12
        static let actionButtonSpacing: CGFloat = 8
        static let actionButtonVerticalPadding: CGFloat = 10
        static let actionButtonHorizontalPadding: CGFloat = 12
        static let actionButtonCornerRadius: CGFloat = 10
    }
    enum Appearance {
        static let errorAccent = Color(red: 0.85, green: 0.35, blue: 0.25)
    }
    enum Strings {
        static let accountsTabTitle = "Счета"
        static let accountsTabSubtitle = "Все счета клиентов"
        static let accountsTabIconName = "creditcard.fill"
        static let clientsTabTitle = "Клиенты"
        static let clientsTabSubtitle = "Клиенты и кредиты"
        static let clientsTabIconName = "person.2.fill"
        static let tariffsTabTitle = "Тарифы"
        static let tariffsTabSubtitle = "Тарифы кредитов"
        static let tariffsTabIconName = "percent"
        static let employeesTabTitle = "Сотрудники"
        static let employeesTabSubtitle = "Управление доступом"
        static let employeesTabIconName = "person.badge.key.fill"
        static let historyButtonTitle = "История"
        static let historyButtonIconName = "list.bullet"
        static let loansButtonTitle = "Кредиты"
        static let loansButtonIconName = "banknote"
        static let blockedBadge = "Заблокирован"
        static let blockIconName = "lock.fill"
        static let unblockIconName = "lock.open.fill"
        static let rateLabel = "Ставка: "
        static let createTariffButtonTitle = "Создать тариф"
        static let createTariffButtonIconName = "plus.circle.fill"
        static let createClientButtonTitle = "Создать клиента"
        static let createClientButtonIconName = "person.badge.plus"
        static let createEmployeeButtonTitle = "Создать сотрудника"
        static let createEmployeeButtonIconName = "person.badge.plus"
        static let errorIconName = "exclamationmark.triangle.fill"
    }
}
