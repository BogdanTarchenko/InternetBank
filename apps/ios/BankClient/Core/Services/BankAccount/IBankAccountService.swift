import Foundation

protocol IBankAccountService {
    func fetchAccounts() async throws -> [BankAccount]
    func openAccount() async throws -> BankAccount
    func closeAccount(id: UUID) async throws
    func deposit(accountId: UUID, amount: Decimal) async throws
    func withdraw(accountId: UUID, amount: Decimal) async throws
    func fetchTransactionHistory(accountId: UUID) async throws -> [Transaction]
    func fetchLoans() async throws -> [Loan]
    func takeLoan(amount: Decimal, currency: String) async throws -> Loan
    func repayLoan(loanId: UUID, amount: Decimal) async throws
}
