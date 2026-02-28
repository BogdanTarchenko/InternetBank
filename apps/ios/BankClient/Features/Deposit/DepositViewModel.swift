import Foundation

@Observable
final class DepositViewModel {
    let bankAccount: BankAccount
    var amount: String = ""
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
        guard let value = Decimal(string: amount.replacingOccurrences(of: ",", with: ".")),
              value > 0 else {
            errorMessage = "Введите сумму"
            return
        }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            try await bankAccountService.deposit(accountId: bankAccount.id, amount: value)
            coordinator.dismissSheet()
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
