import Foundation

@Observable
final class BankAccountListViewModel {
    var accounts: [BankAccount] = []
    var loans: [Loan] = []
    var isLoading = false
    var isOpeningAccount = false
    var isClosingAccountId: UUID?
    var isTakingLoan = false
    var isRepayingLoanId: UUID?
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

    func takeLoan() async {
        isTakingLoan = true
        errorMessage = nil
        defer { isTakingLoan = false }
        do {
            _ = try await bankAccountService.takeLoan(amount: LoanDefaults.amount, currency: LoanDefaults.currency)
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func repayLoan(loan: Loan) async {
        isRepayingLoanId = loan.id
        errorMessage = nil
        defer { isRepayingLoanId = nil }
        do {
            try await bankAccountService.repayLoan(loanId: loan.id, amount: loan.remainingAmount)
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private enum LoanDefaults {
    static let amount: Decimal = 100_000
    static let currency = "RUB"
}
