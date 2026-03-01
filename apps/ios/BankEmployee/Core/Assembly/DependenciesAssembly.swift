import SwiftUI

final class DependenciesAssembly {
    private let coordinator: EmployeeCoordinator = EmployeeCoordinator()
    private let tokenStorage: ITokenStorage = TokenStorage()
    private let currentUserStorage: ICurrentUserStorage = CurrentUserStorage()
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
    private lazy var employeeService: IEmployeeService = ApiEmployeeService(client: apiClient)

    private lazy var loginAssembly = LoginAssembly(
        authService: authService,
        coordinator: coordinator
    )
    private lazy var loginViewModel = loginAssembly.makeViewModel()

    private lazy var registerAssembly = RegisterAssembly(
        authService: authService,
        coordinator: coordinator
    )
    private lazy var registerViewModel = registerAssembly.makeViewModel()

    private lazy var mainListAssembly = MainListAssembly(
        employeeService: employeeService,
        coordinator: coordinator
    )
    private lazy var mainListViewModel = mainListAssembly.makeViewModel()

    private lazy var transactionHistoryAssembly = TransactionHistoryAssembly(
        employeeService: employeeService
    )
    private lazy var createTariffAssembly = CreateTariffAssembly(
        employeeService: employeeService,
        coordinator: coordinator
    )
    private lazy var createClientAssembly = CreateClientAssembly(
        employeeService: employeeService,
        coordinator: coordinator
    )
    private lazy var createEmployeeAssembly = CreateEmployeeAssembly(
        employeeService: employeeService,
        coordinator: coordinator
    )
    private lazy var clientLoansAssembly = ClientLoansAssembly(
        employeeService: employeeService,
        coordinator: coordinator
    )
    private lazy var loanDetailAssembly = LoanDetailAssembly(
        employeeService: employeeService,
        coordinator: coordinator
    )
    private lazy var createLoanAssembly = CreateLoanAssembly(
        employeeService: employeeService,
        coordinator: coordinator
    )

    private lazy var transactionHistoryViewModelFactory = ParameterizedFactory<BankAccount, TransactionHistoryViewModel>(make: { self.transactionHistoryAssembly.makeViewModel(bankAccount: $0) })
    private lazy var createTariffViewModelFactory = Factory<CreateTariffViewModel>(make: { self.createTariffAssembly.makeViewModel() })
    private lazy var createClientViewModelFactory = Factory<CreateClientViewModel>(make: { self.createClientAssembly.makeViewModel() })
    private lazy var createEmployeeViewModelFactory = Factory<CreateEmployeeViewModel>(make: { self.createEmployeeAssembly.makeViewModel() })
    private lazy var clientLoansViewModelFactory = ParameterizedFactory<Client, ClientLoansViewModel>(make: { self.clientLoansAssembly.makeViewModel(client: $0) })
    private lazy var loanDetailViewModelFactory = ParameterizedFactory<Loan, LoanDetailViewModel>(make: { self.loanDetailAssembly.makeViewModel(loan: $0) })
    private lazy var createLoanViewModelFactory = ParameterizedFactory<Client, CreateLoanViewModel>(make: { self.createLoanAssembly.makeViewModel(client: $0) })

    func makeRootView() -> RootView {
        RootView(
            coordinator: coordinator,
            loginViewModel: loginViewModel,
            registerViewModel: registerViewModel,
            mainListViewModel: mainListViewModel,
            transactionHistoryViewModelFactory: transactionHistoryViewModelFactory,
            createTariffViewModelFactory: createTariffViewModelFactory,
            createClientViewModelFactory: createClientViewModelFactory,
            createEmployeeViewModelFactory: createEmployeeViewModelFactory,
            clientLoansViewModelFactory: clientLoansViewModelFactory,
            loanDetailViewModelFactory: loanDetailViewModelFactory,
            createLoanViewModelFactory: createLoanViewModelFactory
        )
    }
}
