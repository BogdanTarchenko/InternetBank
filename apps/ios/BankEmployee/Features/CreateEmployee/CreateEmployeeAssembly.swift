import Foundation

final class CreateEmployeeAssembly {
    private let employeeService: IEmployeeService
    private let coordinator: IEmployeeCoordinator

    init(employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.employeeService = employeeService
        self.coordinator = coordinator
    }

    func makeViewModel() -> CreateEmployeeViewModel {
        CreateEmployeeViewModel(employeeService: employeeService, coordinator: coordinator)
    }
}
