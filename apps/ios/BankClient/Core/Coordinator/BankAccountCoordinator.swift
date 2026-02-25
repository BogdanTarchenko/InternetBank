import SwiftUI

enum BankAccountCoordinatorSheet: Identifiable {
    case openBankAccount
    case closeBankAccount(BankAccount)

    var id: String {
        switch self {
        case .openBankAccount: return "openBankAccount"
        case .closeBankAccount(let bankAccount): return "closeBankAccount-\(bankAccount.id.uuidString)"
        }
    }
}

@Observable
final class BankAccountCoordinator: IBankAccountCoordinator {
    var sheet: BankAccountCoordinatorSheet?
    var navigationPath = NavigationPath()

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
