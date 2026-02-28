import SwiftUI

final class DependenciesAssembly {
    private let coordinator: EmployeeCoordinator = EmployeeCoordinator()
    private let employeeService: IEmployeeService = MockEmployeeService()
    private let authService: IAuthService = MockAuthService()

    private lazy var loginAssembly = LoginAssembly(
        authService: authService,
        coordinator: coordinator
    )
    private lazy var loginViewModel = loginAssembly.makeViewModel()

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
