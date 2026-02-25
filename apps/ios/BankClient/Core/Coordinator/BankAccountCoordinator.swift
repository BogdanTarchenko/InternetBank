import SwiftUI

enum BankAccountCoordinatorSheet: Identifiable {
    case openBankAccount
    case closeBankAccount(BankAccount)

    var id: String {
        switch self {
        case .openBankAccount: return IDs.openBankAccount
        case .closeBankAccount(let bankAccount): return "\(IDs.closeBankAccountPrefix)-\(bankAccount.id.uuidString)"
        }
    }
}

private extension BankAccountCoordinatorSheet {
    enum IDs {
        static let openBankAccount = "openBankAccount"
        static let closeBankAccountPrefix = "closeBankAccount"
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

    func dismissSheet() {
        sheet = nil
    }
}
