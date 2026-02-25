import Foundation

final class TakeLoanAssembly {
    private let coordinator: IBankAccountCoordinator
    private let bankAccountService: IBankAccountService

    init(coordinator: IBankAccountCoordinator, bankAccountService: IBankAccountService) {
        self.coordinator = coordinator
        self.bankAccountService = bankAccountService
    }

    func makeViewModel() -> TakeLoanViewModel {
        TakeLoanViewModel(
            bankAccountService: bankAccountService,
            coordinator: coordinator
        )
    }
}
