import Foundation

final class MockBankAccountService: IBankAccountService {
    func fetchAccounts() async throws -> [BankAccount] {
        []
    }

    func openAccount() async throws -> BankAccount {
        BankAccount(id: UUID(), balance: 0, currency: "RUB")
    }

    func closeAccount(id: UUID) async throws {
    }
}
