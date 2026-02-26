import Foundation

final class LoanDetailAssembly {
    private let employeeService: IEmployeeService
    private let coordinator: IEmployeeCoordinator

    init(employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.employeeService = employeeService
        self.coordinator = coordinator
    }

    func makeViewModel(loan: Loan) -> LoanDetailViewModel {
        LoanDetailViewModel(loan: loan, employeeService: employeeService, coordinator: coordinator)
    }
}
