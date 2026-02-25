import SwiftUI

protocol IBankAccountCoordinator: AnyObject {
    var sheet: BankAccountCoordinatorSheet? { get set }

    func presentOpenBankAccount()
    func presentCloseBankAccount(bankAccount: BankAccount)
    func dismissSheet()
}
