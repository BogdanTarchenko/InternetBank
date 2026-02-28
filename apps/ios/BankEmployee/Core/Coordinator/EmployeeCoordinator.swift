import SwiftUI

enum EmployeeCoordinatorSheet: Identifiable, Equatable {
    case transactionHistory(BankAccount)
    case createTariff
    case createClient
    case createEmployee
    case clientLoans(Client)
    case loanDetail(Loan)

    var id: String {
        switch self {
        case .transactionHistory(let a): return "history-\(a.id.uuidString)"
        case .createTariff: return "createTariff"
        case .createClient: return "createClient"
        case .createEmployee: return "createEmployee"
        case .clientLoans(let c): return "clientLoans-\(c.id.uuidString)"
        case .loanDetail(let l): return "loanDetail-\(l.id.uuidString)"
        }
    }
}

@Observable
final class EmployeeCoordinator: IEmployeeCoordinator {
    var isAuthenticated = false
    var sheet: EmployeeCoordinatorSheet?
    var navigationPath = NavigationPath()

    func didLogin() {
        isAuthenticated = true
    }

    func presentTransactionHistory(account: BankAccount) {
        sheet = .transactionHistory(account)
    }

    func presentCreateTariff() {
        sheet = .createTariff
    }

    func presentCreateClient() {
        sheet = .createClient
    }

    func presentCreateEmployee() {
        sheet = .createEmployee
    }

    func presentClientLoans(client: Client) {
        sheet = .clientLoans(client)
    }

    func presentLoanDetail(loan: Loan) {
        sheet = .loanDetail(loan)
    }

    func dismissSheet() {
        sheet = nil
    }
}
