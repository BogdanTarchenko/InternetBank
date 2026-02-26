import Foundation

protocol IEmployeeService {
    func fetchAllAccounts() async throws -> [BankAccount]
    func fetchTransactionHistory(accountId: UUID) async throws -> [Transaction]
    func fetchClients() async throws -> [Client]
    func fetchEmployees() async throws -> [User]
    func createClient(login: String, password: String, displayName: String) async throws -> Client
    func createEmployee(login: String, password: String, displayName: String) async throws -> User
    func blockClient(id: UUID) async throws
    func unblockClient(id: UUID) async throws
    func blockEmployee(id: UUID) async throws
    func unblockEmployee(id: UUID) async throws
    func fetchLoanTariffs() async throws -> [LoanTariff]
    func createLoanTariff(name: String, rate: Decimal) async throws -> LoanTariff
    func fetchLoans(clientId: UUID) async throws -> [Loan]
    func fetchLoan(id: UUID) async throws -> Loan?
    func fetchClient(id: UUID) async throws -> Client?
    func fetchTariff(id: UUID) async throws -> LoanTariff?
    func createLoan(clientId: UUID, amount: Decimal, tariffId: UUID?) async throws -> Loan
}
