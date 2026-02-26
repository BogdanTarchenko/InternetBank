import Foundation

@Observable
final class ClientLoansViewModel {
    let client: Client
    var loans: [Loan] = []
    var isLoading = false
    var errorMessage: String?

    private let employeeService: IEmployeeService
    private let coordinator: IEmployeeCoordinator

    init(client: Client, employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.client = client
        self.employeeService = employeeService
        self.coordinator = coordinator
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            loans = try await employeeService.fetchLoans(clientId: client.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loanTapped(_ loan: Loan) {
        coordinator.presentLoanDetail(loan: loan)
    }

}
