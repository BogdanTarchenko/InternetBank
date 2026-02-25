import SwiftUI

protocol IBankAccountCoordinator: AnyObject {
    var isAuthenticated: Bool { get }
    var sheet: BankAccountCoordinatorSheet? { get set }

    func didLogin()
    func presentOpenBankAccount()
    func presentCloseBankAccount(bankAccount: BankAccount)
    func dismissSheet()
}
