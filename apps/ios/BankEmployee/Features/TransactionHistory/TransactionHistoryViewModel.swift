import Foundation

@Observable
final class TransactionHistoryViewModel {
    let bankAccount: BankAccount
    var transactions: [Transaction] = []
    var isLoading = false
    var errorMessage: String?

    private let employeeService: IEmployeeService

    init(bankAccount: BankAccount, employeeService: IEmployeeService) {
        self.bankAccount = bankAccount
        self.employeeService = employeeService
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            transactions = try await employeeService.fetchTransactionHistory(accountId: bankAccount.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
