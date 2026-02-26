import SwiftUI

protocol IBankAccountCoordinator: AnyObject {
    var isAuthenticated: Bool { get }
    var sheet: BankAccountCoordinatorSheet? { get set }

    func didLogin()
    func presentDeposit(bankAccount: BankAccount)
    func presentWithdraw(bankAccount: BankAccount)
    func presentTransactionHistory(bankAccount: BankAccount)
    func dismissSheet()
}
