import Foundation

final class ClientLoansAssembly {
    private let employeeService: IEmployeeService
    private let coordinator: IEmployeeCoordinator

    init(employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.employeeService = employeeService
        self.coordinator = coordinator
    }

    func makeViewModel(client: Client) -> ClientLoansViewModel {
        ClientLoansViewModel(client: client, employeeService: employeeService, coordinator: coordinator)
    }
}
