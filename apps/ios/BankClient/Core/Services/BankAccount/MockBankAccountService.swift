import Foundation

final class MockBankAccountService: IBankAccountService {
    private var accounts: [BankAccount] = []
    private var loans: [Loan] = []
    private var transactionsByAccount: [UUID: [Transaction]] = [:]

    func fetchAccounts() async throws -> [BankAccount] {
        accounts
    }

    func openAccount() async throws -> BankAccount {
        let account = BankAccount(id: UUID(), balance: 0, currency: "RUB")
        accounts.append(account)
        return account
    }

    func closeAccount(id: UUID) async throws {
        accounts.removeAll { $0.id == id }
    }

    func deposit(accountId: UUID, amount: Decimal) async throws {
        guard let i = accounts.firstIndex(where: { $0.id == accountId }) else { return }
        accounts[i].balance += amount
        let t = Transaction(id: UUID(), accountId: accountId, type: .deposit, amount: amount, date: Date())
        transactionsByAccount[accountId, default: []].insert(t, at: 0)
    }

    func withdraw(accountId: UUID, amount: Decimal) async throws {
        guard let i = accounts.firstIndex(where: { $0.id == accountId }) else { return }
        accounts[i].balance -= amount
        let t = Transaction(id: UUID(), accountId: accountId, type: .withdrawal, amount: amount, date: Date())
        transactionsByAccount[accountId, default: []].insert(t, at: 0)
    }

    func fetchTransactionHistory(accountId: UUID) async throws -> [Transaction] {
        transactionsByAccount[accountId, default: []]
    }

    func fetchLoans() async throws -> [Loan] {
        loans
    }

    func takeLoan(amount: Decimal, currency: String) async throws -> Loan {
        let loan = Loan(id: UUID(), totalAmount: amount, remainingAmount: amount, currency: currency)
        loans.append(loan)
        return loan
    }

    func repayLoan(loanId: UUID, amount: Decimal) async throws {
        guard let i = loans.firstIndex(where: { $0.id == loanId }) else { return }
        loans[i].remainingAmount -= amount
        if loans[i].remainingAmount <= 0 {
            loans.remove(at: i)
        }
    }
}
