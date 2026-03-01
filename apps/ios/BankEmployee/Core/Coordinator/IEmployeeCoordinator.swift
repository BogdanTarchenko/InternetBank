import SwiftUI

protocol IEmployeeCoordinator: AnyObject {
    var isAuthenticated: Bool { get }
    var sheet: EmployeeCoordinatorSheet? { get set }
    var showRegisterSheet: Bool { get set }

    func didLogin()
    func presentRegister()
    func dismissRegisterSheet()
    func presentTransactionHistory(account: BankAccount)
    func presentCreateTariff()
    func presentCreateClient()
    func presentCreateEmployee()
    func presentClientLoans(client: Client)
    func presentLoanDetail(loan: Loan)
    func dismissSheet()
}
