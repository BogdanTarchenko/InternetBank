import SwiftUI

final class DependenciesAssembly {
    private let bankAccountCoordinator: BankAccountCoordinator = BankAccountCoordinator()
    private let tokenStorage: ITokenStorage = TokenStorage()
    private let currentUserStorage: ICurrentUserStorage = CurrentUserStorage()

    private func setupCoordinatorLogout() {
        bankAccountCoordinator.onLogout = { [weak self] in
            guard let self else { return }
            self.tokenStorage.clear()
            self.currentUserStorage.clear()
            self.bankAccountCoordinator.isAuthenticated = false
        }
    }
    private lazy var apiClient: ApiClient = {
        let c = ApiClient(tokenStorage: tokenStorage)
        c.onUnauthorized = { [weak self] in try await self?.authApi.refresh() ?? () }
        return c
    }()
    private lazy var authApi = AuthApi(client: apiClient, tokenStorage: tokenStorage)
    private lazy var usersApi = UsersApi(client: apiClient)
    private lazy var authService: IAuthService = ApiAuthService(
        authApi: authApi,
        usersApi: usersApi,
        currentUserStorage: currentUserStorage
    )
    private lazy var bankAccountService: IBankAccountService = ApiBankAccountService(
        client: apiClient,
        currentUserStorage: currentUserStorage
    )

    private lazy var loginAssembly = LoginAssembly(
        authService: authService,
        coordinator: bankAccountCoordinator
    )
    private lazy var loginViewModel = loginAssembly.makeViewModel()

    private lazy var registerAssembly = RegisterAssembly(
        authService: authService,
        coordinator: bankAccountCoordinator
    )
    private lazy var registerViewModel = registerAssembly.makeViewModel()

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
    private lazy var takeLoanAssembly = TakeLoanAssembly(
        coordinator: bankAccountCoordinator,
        bankAccountService: bankAccountService
    )
    private lazy var repayLoanAssembly = RepayLoanAssembly(
        coordinator: bankAccountCoordinator,
        bankAccountService: bankAccountService
    )
    private lazy var profileAssembly = ProfileAssembly(
        usersApi: usersApi,
        coordinator: bankAccountCoordinator
    )
    private lazy var profileViewModel = profileAssembly.makeViewModel()
    private lazy var editProfileAssembly = EditProfileAssembly(
        usersApi: usersApi,
        coordinator: bankAccountCoordinator
    )

    private lazy var depositViewModelFactory = ParameterizedFactory<BankAccount, DepositViewModel>(make: { self.depositAssembly.makeViewModel(bankAccount: $0) })
    private lazy var withdrawViewModelFactory = ParameterizedFactory<BankAccount, WithdrawViewModel>(make: { self.withdrawAssembly.makeViewModel(bankAccount: $0) })
    private lazy var transactionHistoryViewModelFactory = ParameterizedFactory<BankAccount, TransactionHistoryViewModel>(make: { self.transactionHistoryAssembly.makeViewModel(bankAccount: $0) })

    func makeRootView() -> RootView {
        setupCoordinatorLogout()
        return RootView(
            coordinator: bankAccountCoordinator,
            loginViewModel: loginViewModel,
            registerViewModel: registerViewModel,
            depositViewModelFactory: depositViewModelFactory,
            withdrawViewModelFactory: withdrawViewModelFactory,
            transactionHistoryViewModelFactory: transactionHistoryViewModelFactory,
            takeLoanAssembly: takeLoanAssembly,
            repayLoanAssembly: repayLoanAssembly,
            editProfileAssembly: editProfileAssembly,
            profileViewModel: profileViewModel,
            listViewModel: bankAccountListViewModel
        )
    }
}
