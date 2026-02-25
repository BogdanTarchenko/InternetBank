import Foundation

@Observable
final class CloseBankAccountViewModel {
    let bankAccount: BankAccount
    var isSubmitting = false
    var errorMessage: String?

    private let bankAccountService: IBankAccountService
    private let coordinator: IBankAccountCoordinator
    var onSuccess: (() -> Void)?

    init(bankAccount: BankAccount, bankAccountService: IBankAccountService, coordinator: IBankAccountCoordinator) {
        self.bankAccount = bankAccount
        self.bankAccountService = bankAccountService
        self.coordinator = coordinator
    }

    func submit() async {
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            try await bankAccountService.closeAccount(id: bankAccount.id)
            coordinator.dismissSheet()
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
