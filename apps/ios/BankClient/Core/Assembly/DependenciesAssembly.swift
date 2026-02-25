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

    private lazy var openBankAccountAssembly = OpenBankAccountAssembly(
        coordinator: bankAccountCoordinator,
        bankAccountService: bankAccountService
    )
    private lazy var closeBankAccountAssembly = CloseBankAccountAssembly(
        coordinator: bankAccountCoordinator,
        bankAccountService: bankAccountService
    )
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

    private lazy var openBankAccountViewModelFactory = Factory<OpenBankAccountViewModel>(make: { self.openBankAccountAssembly.makeViewModel() })
    private lazy var closeBankAccountViewModelFactory = ParameterizedFactory<BankAccount, CloseBankAccountViewModel>(make: { self.closeBankAccountAssembly.makeViewModel(bankAccount: $0) })
    private lazy var depositViewModelFactory = ParameterizedFactory<BankAccount, DepositViewModel>(make: { self.depositAssembly.makeViewModel(bankAccount: $0) })
    private lazy var withdrawViewModelFactory = ParameterizedFactory<BankAccount, WithdrawViewModel>(make: { self.withdrawAssembly.makeViewModel(bankAccount: $0) })
    private lazy var transactionHistoryViewModelFactory = ParameterizedFactory<BankAccount, TransactionHistoryViewModel>(make: { self.transactionHistoryAssembly.makeViewModel(bankAccount: $0) })
    private lazy var takeLoanViewModelFactory = Factory<TakeLoanViewModel>(make: { self.takeLoanAssembly.makeViewModel() })
    private lazy var repayLoanViewModelFactory = ParameterizedFactory<Loan, RepayLoanViewModel>(make: { self.repayLoanAssembly.makeViewModel(loan: $0) })

    func makeRootView() -> RootView {
        RootView(
            coordinator: bankAccountCoordinator,
            loginViewModel: loginViewModel,
            openBankAccountViewModelFactory: openBankAccountViewModelFactory,
            closeBankAccountViewModelFactory: closeBankAccountViewModelFactory,
            depositViewModelFactory: depositViewModelFactory,
            withdrawViewModelFactory: withdrawViewModelFactory,
            transactionHistoryViewModelFactory: transactionHistoryViewModelFactory,
            takeLoanViewModelFactory: takeLoanViewModelFactory,
            repayLoanViewModelFactory: repayLoanViewModelFactory,
            listViewModel: bankAccountListViewModel
        )
    }
}
