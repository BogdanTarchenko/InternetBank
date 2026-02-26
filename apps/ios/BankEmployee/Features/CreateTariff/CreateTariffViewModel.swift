import Foundation

@Observable
final class CreateTariffViewModel {
    var name = ""
    var rateText = ""
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
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Введите название"
            return
        }
        guard let rate = Decimal(string: rateText.replacingOccurrences(of: ",", with: ".")),
              rate >= 0 else {
            errorMessage = "Введите корректную ставку"
            return
        }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            _ = try await employeeService.createLoanTariff(name: name.trimmingCharacters(in: .whitespacesAndNewlines), rate: rate)
            coordinator.dismissSheet()
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
