import Foundation

final class RepayLoanAssembly {
    private let coordinator: IBankAccountCoordinator
    private let bankAccountService: IBankAccountService

    init(coordinator: IBankAccountCoordinator, bankAccountService: IBankAccountService) {
        self.coordinator = coordinator
        self.bankAccountService = bankAccountService
    }

    func makeViewModel(loan: Loan) -> RepayLoanViewModel {
        RepayLoanViewModel(
            loan: loan,
            bankAccountService: bankAccountService,
            coordinator: coordinator
        )
    }
}
