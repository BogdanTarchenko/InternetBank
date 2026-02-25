import SwiftUI

enum BankAccountCoordinatorSheet: Identifiable, Equatable {
    case openBankAccount
    case closeBankAccount(BankAccount)
    case deposit(BankAccount)
    case withdraw(BankAccount)
    case transactionHistory(BankAccount)
    case takeLoan
    case repayLoan(Loan)

    var id: String {
        switch self {
        case .openBankAccount: return IDs.openBankAccount
        case .closeBankAccount(let a): return "\(IDs.closeBankAccountPrefix)-\(a.id.uuidString)"
        case .deposit(let a): return "\(IDs.depositPrefix)-\(a.id.uuidString)"
        case .withdraw(let a): return "\(IDs.withdrawPrefix)-\(a.id.uuidString)"
        case .transactionHistory(let a): return "\(IDs.historyPrefix)-\(a.id.uuidString)"
        case .takeLoan: return IDs.takeLoan
        case .repayLoan(let l): return "\(IDs.repayLoanPrefix)-\(l.id.uuidString)"
        }
    }
}

private extension BankAccountCoordinatorSheet {
    enum IDs {
        static let openBankAccount = "openBankAccount"
        static let closeBankAccountPrefix = "closeBankAccount"
        static let depositPrefix = "deposit"
        static let withdrawPrefix = "withdraw"
        static let historyPrefix = "history"
        static let takeLoan = "takeLoan"
        static let repayLoanPrefix = "repayLoan"
    }
}

@Observable
final class BankAccountCoordinator: IBankAccountCoordinator {
    var isAuthenticated = false
    var sheet: BankAccountCoordinatorSheet?
    var navigationPath = NavigationPath()

    func didLogin() {
        isAuthenticated = true
    }

    func presentOpenBankAccount() {
        sheet = .openBankAccount
    }

    func presentCloseBankAccount(bankAccount: BankAccount) {
        sheet = .closeBankAccount(bankAccount)
    }

    func presentDeposit(bankAccount: BankAccount) {
        sheet = .deposit(bankAccount)
    }

    func presentWithdraw(bankAccount: BankAccount) {
        sheet = .withdraw(bankAccount)
    }

    func presentTransactionHistory(bankAccount: BankAccount) {
        sheet = .transactionHistory(bankAccount)
    }

    func presentTakeLoan() {
        sheet = .takeLoan
    }

    func presentRepayLoan(loan: Loan) {
        sheet = .repayLoan(loan)
    }

    func dismissSheet() {
        sheet = nil
    }
}
