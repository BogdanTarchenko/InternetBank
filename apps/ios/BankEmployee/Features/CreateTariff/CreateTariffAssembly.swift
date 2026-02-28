import Foundation

final class CreateTariffAssembly {
    private let employeeService: IEmployeeService
    private let coordinator: IEmployeeCoordinator

    init(employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.employeeService = employeeService
        self.coordinator = coordinator
    }

    func makeViewModel() -> CreateTariffViewModel {
        CreateTariffViewModel(employeeService: employeeService, coordinator: coordinator)
    }
}
