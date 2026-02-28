import SwiftUI

struct RootView: View {
    let coordinator: BankAccountCoordinator
    let loginViewModel: LoginViewModel
    let depositViewModelFactory: ParameterizedFactory<BankAccount, DepositViewModel>
    let withdrawViewModelFactory: ParameterizedFactory<BankAccount, WithdrawViewModel>
    let transactionHistoryViewModelFactory: ParameterizedFactory<BankAccount, TransactionHistoryViewModel>
    let listViewModel: BankAccountListViewModel

    var body: some View {
        Group {
            if coordinator.isAuthenticated {
                mainContent
            } else {
                LoginView(viewModel: loginViewModel)
            }
        }
    }

    private var mainContent: some View {
        BankAccountListView(viewModel: listViewModel)
            .sheet(item: Binding(
                get: { coordinator.sheet },
                set: { coordinator.sheet = $0 }
            )) { sheet in
                sheetContent(sheet)
            }
            .onChange(of: coordinator.sheet) { _, newValue in
                if newValue == nil {
                    Task { await listViewModel.load() }
                }
            }
    }

    @ViewBuilder
    private func sheetContent(_ sheet: BankAccountCoordinatorSheet) -> some View {
        switch sheet {
        case .deposit(let bankAccount):
            DepositView(viewModel: depositViewModelFactory.make(bankAccount))
        case .withdraw(let bankAccount):
            WithdrawView(viewModel: withdrawViewModelFactory.make(bankAccount))
        case .transactionHistory(let bankAccount):
            TransactionHistoryView(viewModel: transactionHistoryViewModelFactory.make(bankAccount))
        }
    }
}
