import SwiftUI

struct RootView: View {
    let coordinator: BankAccountCoordinator
    let loginViewModel: LoginViewModel
    let registerViewModel: RegisterViewModel
    let depositViewModelFactory: ParameterizedFactory<BankAccount, DepositViewModel>
    let withdrawViewModelFactory: ParameterizedFactory<BankAccount, WithdrawViewModel>
    let transactionHistoryViewModelFactory: ParameterizedFactory<BankAccount, TransactionHistoryViewModel>
    let takeLoanAssembly: TakeLoanAssembly
    let repayLoanAssembly: RepayLoanAssembly
    let editProfileAssembly: EditProfileAssembly
    let profileViewModel: ProfileViewModel
    let listViewModel: BankAccountListViewModel

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
        BankAccountListView(viewModel: listViewModel, profileViewModel: profileViewModel)
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
        case .takeLoan:
            TakeLoanView(viewModel: takeLoanAssembly.makeViewModel())
        case .repayLoan(let loan):
            RepayLoanView(viewModel: repayLoanAssembly.makeViewModel(loan: loan))
        case .editProfile(let item):
            EditProfileView(viewModel: editProfileAssembly.makeViewModel(item: item, onSuccess: { Task { await profileViewModel.load() } }))
        }
    }
}
