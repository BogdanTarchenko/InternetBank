import SwiftUI

final class DependenciesAssembly {
    private let bankAccountCoordinator: BankAccountCoordinator = BankAccountCoordinator()
    private let bankAccountService: IBankAccountService = MockBankAccountService()
    private let authService: IAuthService = MockAuthService()

    private lazy var loginAssembly = LoginAssembly(
        authService: authService,
        coordinator: bankAccountCoordinator
    )
    private lazy var loginViewModel = loginAssembly.makeViewModel()

    private lazy var bankAccountListAssembly = BankAccountListAssembly(
        coordinator: bankAccountCoordinator,
        bankAccountService: bankAccountService
    )
    private lazy var bankAccountListViewModel = bankAccountListAssembly.makeViewModel()

    private lazy var depositAssembly = DepositAssembly(
        coordinator: bankAccountCoordinator,
        bankAccountService: bankAccountService
    )
    private lazy var withdrawAssembly = WithdrawAssembly(
        coordinator: bankAccountCoordinator,
        bankAccountService: bankAccountService
    )
    private lazy var transactionHistoryAssembly = TransactionHistoryAssembly(
        bankAccountService: bankAccountService
    )

    private lazy var depositViewModelFactory = ParameterizedFactory<BankAccount, DepositViewModel>(make: { self.depositAssembly.makeViewModel(bankAccount: $0) })
    private lazy var withdrawViewModelFactory = ParameterizedFactory<BankAccount, WithdrawViewModel>(make: { self.withdrawAssembly.makeViewModel(bankAccount: $0) })
    private lazy var transactionHistoryViewModelFactory = ParameterizedFactory<BankAccount, TransactionHistoryViewModel>(make: { self.transactionHistoryAssembly.makeViewModel(bankAccount: $0) })

    func makeRootView() -> RootView {
        RootView(
            coordinator: bankAccountCoordinator,
            loginViewModel: loginViewModel,
            depositViewModelFactory: depositViewModelFactory,
            withdrawViewModelFactory: withdrawViewModelFactory,
            transactionHistoryViewModelFactory: transactionHistoryViewModelFactory,
            listViewModel: bankAccountListViewModel
        )
    }
}
