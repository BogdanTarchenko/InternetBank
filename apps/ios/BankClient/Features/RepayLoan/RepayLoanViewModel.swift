import Foundation

@Observable
final class RepayLoanViewModel {
    let loan: Loan
    var amount: String = ""
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
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            try await bankAccountService.repayLoan(loanId: loan.id, amount: value)
            coordinator.dismissSheet()
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
