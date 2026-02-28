import Foundation

final class CreateLoanAssembly {
    private let employeeService: IEmployeeService

    init(employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.employeeService = employeeService
    }

    func makeViewModel(client: Client) -> CreateLoanViewModel {
        CreateLoanViewModel(client: client, employeeService: employeeService)
    }
}
