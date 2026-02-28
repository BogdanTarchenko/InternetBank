import Foundation

final class TransactionHistoryAssembly {
    private let employeeService: IEmployeeService

    init(employeeService: IEmployeeService) {
        self.employeeService = employeeService
    }

    func makeViewModel(bankAccount: BankAccount) -> TransactionHistoryViewModel {
        TransactionHistoryViewModel(bankAccount: bankAccount, employeeService: employeeService)
    }
}
