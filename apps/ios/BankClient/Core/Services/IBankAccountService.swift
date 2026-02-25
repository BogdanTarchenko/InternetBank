import Foundation

protocol IBankAccountService {
    func fetchAccounts() async throws -> [BankAccount]
    func openAccount() async throws -> BankAccount
    func closeAccount(id: UUID) async throws
}
