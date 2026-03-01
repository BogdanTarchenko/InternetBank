import SwiftUI

struct RootView: View {
    let coordinator: EmployeeCoordinator
    let loginViewModel: LoginViewModel
    let registerViewModel: RegisterViewModel
    let mainListViewModel: MainListViewModel
    let transactionHistoryViewModelFactory: ParameterizedFactory<BankAccount, TransactionHistoryViewModel>
    let createTariffViewModelFactory: Factory<CreateTariffViewModel>
    let createClientViewModelFactory: Factory<CreateClientViewModel>
    let createEmployeeViewModelFactory: Factory<CreateEmployeeViewModel>
    let clientLoansViewModelFactory: ParameterizedFactory<Client, ClientLoansViewModel>
    let loanDetailViewModelFactory: ParameterizedFactory<Loan, LoanDetailViewModel>
    let createLoanViewModelFactory: ParameterizedFactory<Client, CreateLoanViewModel>

    var body: some View {
        Group {
            if coordinator.isAuthenticated {
                mainContent
            } else if coordinator.showRegisterSheet {
                RegisterView(viewModel: registerViewModel)
            } else {
                LoginView(viewModel: loginViewModel)
            }
        }
    }

    private var mainContent: some View {
        MainListView(viewModel: mainListViewModel)
            .sheet(item: Binding(
                get: { coordinator.sheet },
                set: { coordinator.sheet = $0 }
            )) { sheet in
                sheetContent(sheet)
            }
            .onChange(of: coordinator.sheet) { _, newValue in
                if newValue == nil {
                    Task { await mainListViewModel.load() }
                }
            }
    }

    @ViewBuilder
    private func sheetContent(_ sheet: EmployeeCoordinatorSheet) -> some View {
        switch sheet {
        case .transactionHistory(let account):
            TransactionHistoryView(viewModel: transactionHistoryViewModelFactory.make(account))
        case .createTariff:
            CreateTariffView(viewModel: createTariffViewModelFactory.make())
        case .createClient:
            CreateClientView(viewModel: createClientViewModelFactory.make())
        case .createEmployee:
            CreateEmployeeView(viewModel: createEmployeeViewModelFactory.make())
        case .clientLoans(let client):
            ClientLoansView(viewModel: clientLoansViewModelFactory.make(client), createLoanViewModelFactory: createLoanViewModelFactory)
        case .loanDetail(let loan):
            LoanDetailView(viewModel: loanDetailViewModelFactory.make(loan))
        }
    }
}
