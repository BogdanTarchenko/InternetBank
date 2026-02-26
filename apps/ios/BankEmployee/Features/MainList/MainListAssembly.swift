import Foundation

final class MainListAssembly {
    private let employeeService: IEmployeeService
    private let coordinator: IEmployeeCoordinator

    init(employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.employeeService = employeeService
        self.coordinator = coordinator
    }

    func makeViewModel() -> MainListViewModel {
        MainListViewModel(employeeService: employeeService, coordinator: coordinator)
    }
}
