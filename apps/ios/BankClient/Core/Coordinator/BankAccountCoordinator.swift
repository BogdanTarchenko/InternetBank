import SwiftUI

enum BankAccountCoordinatorSheet: Identifiable, Equatable {
    case deposit(BankAccount)
    case withdraw(BankAccount)
    case transactionHistory(BankAccount)
    case takeLoan
    case repayLoan(Loan)
    case editProfile(EditProfileItem)

    var id: String {
        switch self {
        case .deposit(let a): return "\(IDs.depositPrefix)-\(a.id.uuidString)"
        case .withdraw(let a): return "\(IDs.withdrawPrefix)-\(a.id.uuidString)"
        case .transactionHistory(let a): return "\(IDs.historyPrefix)-\(a.id.uuidString)"
        case .takeLoan: return IDs.takeLoan
        case .repayLoan(let loan): return "\(IDs.repayPrefix)-\(loan.id.uuidString)"
        case .editProfile(let item): return "\(IDs.editProfilePrefix)-\(item.id)"
        }
    }
}

private extension BankAccountCoordinatorSheet {
    enum IDs {
        static let depositPrefix = "deposit"
        static let withdrawPrefix = "withdraw"
        static let historyPrefix = "history"
        static let takeLoan = "takeLoan"
        static let repayPrefix = "repay"
        static let editProfilePrefix = "editProfile"
    }
}

@Observable
final class BankAccountCoordinator: IBankAccountCoordinator {
    var isAuthenticated = false
    var sheet: BankAccountCoordinatorSheet?
    var showRegisterSheet = false
    var navigationPath = NavigationPath()
    var onLogout: (() -> Void)?

    func didLogin() {
        isAuthenticated = true
    }

    func presentRegister() {
        showRegisterSheet = true
    }

    func dismissRegisterSheet() {
        showRegisterSheet = false
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

    func presentEditProfile(userId: UUID, name: String, email: String) {
        sheet = .editProfile(EditProfileItem(userId: userId, name: name, email: email))
    }

    func logout() {
        onLogout?()
    }

    func dismissSheet() {
        sheet = nil
    }
}
