import Foundation

@Observable
final class LoanDetailViewModel {
    let loan: Loan
    var tariffName: String?
    var isLoading = false
    var errorMessage: String?

    private let employeeService: IEmployeeService
    private let coordinator: IEmployeeCoordinator

    init(loan: Loan, employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.loan = loan
        self.employeeService = employeeService
        self.coordinator = coordinator
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        if let tid = loan.tariffId {
            do {
                tariffName = try await employeeService.fetchTariff(id: tid)?.name
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
