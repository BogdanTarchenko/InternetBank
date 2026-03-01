import Foundation

@Observable
final class RepayLoanViewModel {
    let loan: Loan
    var accounts: [BankAccount] = []
    var selectedAccountId: UUID?
    var amount: String = ""
    var isLoading = false
    var isSubmitting = false
    var errorMessage: String?

    private let bankAccountService: IBankAccountService
    private let coordinator: IBankAccountCoordinator
    var onSuccess: (() -> Void)?

    init(loan: Loan, bankAccountService: IBankAccountService, coordinator: IBankAccountCoordinator) {
        self.loan = loan
        self.bankAccountService = bankAccountService
        self.coordinator = coordinator
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            accounts = try await bankAccountService.fetchAccounts()
            if selectedAccountId == nil, let first = accounts.first { selectedAccountId = first.id }
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
        if value > loan.remainingAmount {
            errorMessage = "Сумма превышает остаток долга"
            return
        }
        guard let accountId = selectedAccountId else {
            errorMessage = "Выберите счёт для списания"
            return
        }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            try await bankAccountService.repayLoan(loan: loan, amount: value, accountId: accountId)
            coordinator.dismissSheet()
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
