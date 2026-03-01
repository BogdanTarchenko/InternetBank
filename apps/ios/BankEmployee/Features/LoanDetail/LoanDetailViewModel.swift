import Foundation

@Observable
final class LoanDetailViewModel {
    let loan: Loan
    var loadedLoan: Loan?
    var tariffName: String?
    var isLoading = false
    var errorMessage: String?

    private let employeeService: IEmployeeService
    private let coordinator: IEmployeeCoordinator

    var displayLoan: Loan { loadedLoan ?? loan }

    init(loan: Loan, employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.loan = loan
        self.employeeService = employeeService
        self.coordinator = coordinator
    }

    func load() async {
        if let creditId = loan.apiCreditId {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            do {
                loadedLoan = try await employeeService.fetchLoanDetail(creditId: creditId)
                tariffName = loadedLoan?.tariffName ?? loan.tariffName
            } catch {
                errorMessage = error.localizedDescription
            }
            return
        }
        if let name = loan.tariffName {
            tariffName = name
            return
        }
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
