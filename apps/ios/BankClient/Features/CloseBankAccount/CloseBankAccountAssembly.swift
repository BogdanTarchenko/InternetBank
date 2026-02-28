import Foundation

final class CloseBankAccountAssembly {
    private let coordinator: IBankAccountCoordinator
    private let bankAccountService: IBankAccountService

    init(coordinator: IBankAccountCoordinator, bankAccountService: IBankAccountService) {
        self.coordinator = coordinator
        self.bankAccountService = bankAccountService
    }

    func makeViewModel(bankAccount: BankAccount) -> CloseBankAccountViewModel {
        CloseBankAccountViewModel(
            bankAccount: bankAccount,
            bankAccountService: bankAccountService,
            coordinator: coordinator
        )
    }
}
