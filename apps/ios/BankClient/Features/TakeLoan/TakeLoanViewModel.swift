import Foundation

@Observable
final class TakeLoanViewModel {
    var amount: String = ""
    var currency: String = "RUB"
    var isSubmitting = false
    var errorMessage: String?

    private let bankAccountService: IBankAccountService
    private let coordinator: IBankAccountCoordinator
    var onSuccess: (() -> Void)?

    init(bankAccountService: IBankAccountService, coordinator: IBankAccountCoordinator) {
        self.bankAccountService = bankAccountService
        self.coordinator = coordinator
    }

    func submit() async {
        guard let value = Decimal(string: amount.replacingOccurrences(of: ",", with: ".")),
              value > 0 else {
            errorMessage = "Введите сумму"
            return
        }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            _ = try await bankAccountService.takeLoan(amount: value, currency: currency)
            coordinator.dismissSheet()
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
