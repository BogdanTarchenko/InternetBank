import Foundation

final class OpenBankAccountAssembly {
    private let coordinator: IBankAccountCoordinator
    private let bankAccountService: IBankAccountService

    init(coordinator: IBankAccountCoordinator, bankAccountService: IBankAccountService) {
        self.coordinator = coordinator
        self.bankAccountService = bankAccountService
    }

    func makeViewModel() -> OpenBankAccountViewModel {
        OpenBankAccountViewModel(
            bankAccountService: bankAccountService,
            coordinator: coordinator
        )
    }
}
