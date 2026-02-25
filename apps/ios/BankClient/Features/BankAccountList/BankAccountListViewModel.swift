import Foundation

@Observable
final class BankAccountListViewModel {
    var accounts: [BankAccount] = []
    var isLoading = false
    var errorMessage: String?

    private let bankAccountService: IBankAccountService
    private let coordinator: IBankAccountCoordinator

    init(bankAccountService: IBankAccountService, coordinator: IBankAccountCoordinator) {
        self.bankAccountService = bankAccountService
        self.coordinator = coordinator
    }

    func loadAccounts() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            accounts = try await bankAccountService.fetchAccounts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func openBankAccountTapped() {
        coordinator.presentOpenBankAccount()
    }

    func closeBankAccountTapped(bankAccount: BankAccount) {
        coordinator.presentCloseBankAccount(bankAccount: bankAccount)
    }
}
