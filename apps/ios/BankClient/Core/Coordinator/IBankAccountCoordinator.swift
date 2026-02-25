import SwiftUI

protocol IBankAccountCoordinator: AnyObject {
    var isAuthenticated: Bool { get }
    var sheet: BankAccountCoordinatorSheet? { get set }

    func didLogin()
    func presentOpenBankAccount()
    func presentCloseBankAccount(bankAccount: BankAccount)
    func presentDeposit(bankAccount: BankAccount)
    func presentWithdraw(bankAccount: BankAccount)
    func presentTransactionHistory(bankAccount: BankAccount)
    func presentTakeLoan()
    func presentRepayLoan(loan: Loan)
    func dismissSheet()
}
