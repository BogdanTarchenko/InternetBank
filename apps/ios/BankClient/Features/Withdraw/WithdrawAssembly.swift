import Foundation

final class WithdrawAssembly {
    private let coordinator: IBankAccountCoordinator
    private let bankAccountService: IBankAccountService

    init(coordinator: IBankAccountCoordinator, bankAccountService: IBankAccountService) {
        self.coordinator = coordinator
        self.bankAccountService = bankAccountService
    }

    func makeViewModel(bankAccount: BankAccount) -> WithdrawViewModel {
        WithdrawViewModel(
            bankAccount: bankAccount,
            bankAccountService: bankAccountService,
            coordinator: coordinator
        )
    }
}
