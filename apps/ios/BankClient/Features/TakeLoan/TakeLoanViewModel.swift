import Foundation

@Observable
final class TakeLoanViewModel {
    var accounts: [BankAccount] = []
    var tariffs: [LoanTariff] = []
    var selectedAccountId: UUID?
    var selectedTariffId: Int64?
    var amount: String = ""
    var isLoading = false
    var isSubmitting = false
    var errorMessage: String?

    private let bankAccountService: IBankAccountService
    private let coordinator: IBankAccountCoordinator
    var onSuccess: (() -> Void)?

    init(bankAccountService: IBankAccountService, coordinator: IBankAccountCoordinator) {
        self.bankAccountService = bankAccountService
        self.coordinator = coordinator
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let accountsTask = bankAccountService.fetchAccounts()
            async let tariffsTask = bankAccountService.fetchTariffs()
            let (accs, tars) = try await (accountsTask, tariffsTask)
            accounts = accs
            tariffs = tars
            if selectedAccountId == nil, let first = accs.first { selectedAccountId = first.id }
            if selectedTariffId == nil, let first = tars.first { selectedTariffId = first.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func submit() async {
        guard let value = Decimal(string: amount.replacingOccurrences(of: ",", with: ".")),
              value > 0 else {
            errorMessage = "Введите сумму"
            return
        }
        guard let accountId = selectedAccountId else {
            errorMessage = "Выберите счёт для зачисления"
            return
        }
        guard let tariffId = selectedTariffId else {
            errorMessage = "Выберите тариф"
            return
        }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            _ = try await bankAccountService.takeLoan(amount: value, accountId: accountId, tariffId: tariffId)
            coordinator.dismissSheet()
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
