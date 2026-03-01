import Foundation

@Observable
final class BankAccountListViewModel {
    var accounts: [BankAccount] = []
    var loans: [Loan] = []
    var isLoading = false
    var isOpeningAccount = false
    var isClosingAccountId: UUID?
    var errorMessage: String?

    private let bankAccountService: IBankAccountService
    private let coordinator: IBankAccountCoordinator

    init(bankAccountService: IBankAccountService, coordinator: IBankAccountCoordinator) {
        self.bankAccountService = bankAccountService
        self.coordinator = coordinator
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let accountsTask = bankAccountService.fetchAccounts()
            async let loansTask = bankAccountService.fetchLoans()
            accounts = try await accountsTask
            loans = try await loansTask
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func openBankAccount() async {
        isOpeningAccount = true
        errorMessage = nil
        defer { isOpeningAccount = false }
        do {
            _ = try await bankAccountService.openAccount()
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func closeBankAccount(bankAccount: BankAccount) async {
        isClosingAccountId = bankAccount.id
        errorMessage = nil
        defer { isClosingAccountId = nil }
        do {
            try await bankAccountService.closeAccount(id: bankAccount.id)
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func depositTapped(bankAccount: BankAccount) {
        coordinator.presentDeposit(bankAccount: bankAccount)
    }

    func withdrawTapped(bankAccount: BankAccount) {
        coordinator.presentWithdraw(bankAccount: bankAccount)
    }

    func transactionHistoryTapped(bankAccount: BankAccount) {
        coordinator.presentTransactionHistory(bankAccount: bankAccount)
    }

    func takeLoanTapped() {
        coordinator.presentTakeLoan()
    }

    func repayTapped(loan: Loan) {
        coordinator.presentRepayLoan(loan: loan)
    }
}
