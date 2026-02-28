import Foundation

final class BankAccountListAssembly {
    private let coordinator: IBankAccountCoordinator
    private let bankAccountService: IBankAccountService

    init(coordinator: IBankAccountCoordinator, bankAccountService: IBankAccountService) {
        self.coordinator = coordinator
        self.bankAccountService = bankAccountService
    }

    func makeViewModel() -> BankAccountListViewModel {
        BankAccountListViewModel(
            bankAccountService: bankAccountService,
            coordinator: coordinator
        )
    }
}
