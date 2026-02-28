import Foundation

@Observable
final class TransactionHistoryViewModel {
    let bankAccount: BankAccount
    var transactions: [Transaction] = []
    var isLoading = false
    var errorMessage: String?

    private let bankAccountService: IBankAccountService

    init(bankAccount: BankAccount, bankAccountService: IBankAccountService) {
        self.bankAccount = bankAccount
        self.bankAccountService = bankAccountService
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            transactions = try await bankAccountService.fetchTransactionHistory(accountId: bankAccount.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
