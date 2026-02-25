import SwiftUI

struct RootView: View {
    let coordinator: BankAccountCoordinator
    let loginViewModel: LoginViewModel
    let openBankAccountViewModelFactory: Factory<OpenBankAccountViewModel>
    let closeBankAccountViewModelFactory: ParameterizedFactory<BankAccount, CloseBankAccountViewModel>
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
    }

    @ViewBuilder
    private func sheetContent(_ sheet: BankAccountCoordinatorSheet) -> some View {
        switch sheet {
        case .openBankAccount:
            OpenBankAccountView(viewModel: openBankAccountViewModelFactory.make())
        case .closeBankAccount(let bankAccount):
            CloseBankAccountView(viewModel: closeBankAccountViewModelFactory.make(bankAccount))
        }
    }
}
