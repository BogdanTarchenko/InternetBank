import Foundation

@Observable
final class CreateEmployeeViewModel {
    var login = ""
    var password = ""
    var displayName = ""
    var isSubmitting = false
    var errorMessage: String?

    private let employeeService: IEmployeeService
    private let coordinator: IEmployeeCoordinator
    var onSuccess: (() -> Void)?

    init(employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.employeeService = employeeService
        self.coordinator = coordinator
    }

    func submit() async {
        let errors = LoginValidator.validate(login: login, password: password)
        if !errors.isEmpty {
            errorMessage = errors.first?.message
            return
        }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            _ = try await employeeService.createEmployee(login: login.trimmingCharacters(in: .whitespacesAndNewlines), password: password, displayName: displayName.trimmingCharacters(in: .whitespacesAndNewlines))
            coordinator.dismissSheet()
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
