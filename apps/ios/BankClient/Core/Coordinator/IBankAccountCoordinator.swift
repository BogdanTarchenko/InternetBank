import SwiftUI

protocol IBankAccountCoordinator: AnyObject {
    var isAuthenticated: Bool { get }
    var sheet: BankAccountCoordinatorSheet? { get set }
    var showRegisterSheet: Bool { get set }

    func didLogin()
    func presentRegister()
    func dismissRegisterSheet()
    func presentDeposit(bankAccount: BankAccount)
    func presentWithdraw(bankAccount: BankAccount)
    func presentTransactionHistory(bankAccount: BankAccount)
    func presentTakeLoan()
    func presentRepayLoan(loan: Loan)
    func presentEditProfile(userId: UUID, name: String, email: String)
    func logout()
    func dismissSheet()
}
