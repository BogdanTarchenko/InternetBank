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

    private lazy var openBankAccountAssembly = OpenBankAccountAssembly(
        coordinator: bankAccountCoordinator,
        bankAccountService: bankAccountService
    )

    private lazy var closeBankAccountAssembly = CloseBankAccountAssembly(
        coordinator: bankAccountCoordinator,
        bankAccountService: bankAccountService
    )

    private lazy var bankAccountListViewModel = bankAccountListAssembly.makeViewModel()
    private lazy var openBankAccountViewModelFactory = Factory<OpenBankAccountViewModel>(make: { self.openBankAccountAssembly.makeViewModel() })
    private lazy var closeBankAccountViewModelFactory = ParameterizedFactory<BankAccount, CloseBankAccountViewModel>(make: { self.closeBankAccountAssembly.makeViewModel(bankAccount: $0) })

    func makeRootView() -> RootView {
        RootView(
            coordinator: bankAccountCoordinator,
            loginViewModel: loginViewModel,
            openBankAccountViewModelFactory: openBankAccountViewModelFactory,
            closeBankAccountViewModelFactory: closeBankAccountViewModelFactory,
            listViewModel: bankAccountListViewModel
        )
    }
}
