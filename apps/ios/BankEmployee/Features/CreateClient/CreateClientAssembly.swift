import Foundation

final class CreateClientAssembly {
    private let employeeService: IEmployeeService
    private let coordinator: IEmployeeCoordinator

    init(employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.employeeService = employeeService
        self.coordinator = coordinator
    }

    func makeViewModel() -> CreateClientViewModel {
        CreateClientViewModel(employeeService: employeeService, coordinator: coordinator)
    }
}
