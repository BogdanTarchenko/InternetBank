import Foundation

@Observable
final class OpenBankAccountViewModel {
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
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            _ = try await bankAccountService.openAccount()
            coordinator.dismissSheet()
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
