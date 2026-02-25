import Foundation

final class DepositAssembly {
    private let coordinator: IBankAccountCoordinator
    private let bankAccountService: IBankAccountService

    init(coordinator: IBankAccountCoordinator, bankAccountService: IBankAccountService) {
        self.coordinator = coordinator
        self.bankAccountService = bankAccountService
    }

    func makeViewModel(bankAccount: BankAccount) -> DepositViewModel {
        DepositViewModel(
            bankAccount: bankAccount,
            bankAccountService: bankAccountService,
            coordinator: coordinator
        )
    }
}
