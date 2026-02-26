import SwiftUI

enum BankAccountCoordinatorSheet: Identifiable, Equatable {
    case deposit(BankAccount)
    case withdraw(BankAccount)
    case transactionHistory(BankAccount)

    var id: String {
        switch self {
        case .deposit(let a): return "\(IDs.depositPrefix)-\(a.id.uuidString)"
        case .withdraw(let a): return "\(IDs.withdrawPrefix)-\(a.id.uuidString)"
        case .transactionHistory(let a): return "\(IDs.historyPrefix)-\(a.id.uuidString)"
        }
    }
}

private extension BankAccountCoordinatorSheet {
    enum IDs {
        static let depositPrefix = "deposit"
        static let withdrawPrefix = "withdraw"
        static let historyPrefix = "history"
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

    func presentDeposit(bankAccount: BankAccount) {
        sheet = .deposit(bankAccount)
    }

    func presentWithdraw(bankAccount: BankAccount) {
        sheet = .withdraw(bankAccount)
    }

    func presentTransactionHistory(bankAccount: BankAccount) {
        sheet = .transactionHistory(bankAccount)
    }

    func dismissSheet() {
        sheet = nil
    }
}
