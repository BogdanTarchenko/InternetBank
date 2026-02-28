import Foundation

final class TransactionHistoryAssembly {
    private let bankAccountService: IBankAccountService

    init(bankAccountService: IBankAccountService) {
        self.bankAccountService = bankAccountService
    }

    func makeViewModel(bankAccount: BankAccount) -> TransactionHistoryViewModel {
        TransactionHistoryViewModel(
            bankAccount: bankAccount,
            bankAccountService: bankAccountService
        )
    }
}
