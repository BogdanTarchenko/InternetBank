import Foundation

final class MockEmployeeService: IEmployeeService {
    private var clients: [Client] = []
    private var employees: [User] = []
    private var accounts: [BankAccount] = []
    private var loans: [Loan] = []
    private var tariffs: [LoanTariff] = []
    private var transactionsByAccount: [UUID: [Transaction]] = [:]
    private let minutesPerYear: Decimal = 365 * 24 * 60

    init() {
        Task { await runMinuteTimer() }
    }

    private func runMinuteTimer() async {
        while true {
            try? await Task.sleep(nanoseconds: 60_000_000_000)
            applyInterestToLoans()
        }
    }

    private func applyInterestToLoans() {
        for i in loans.indices {
            guard let tid = loans[i].tariffId,
                  let tariff = tariffs.first(where: { $0.id == tid }),
                  loans[i].remainingAmount > 0 else { continue }
            let rate = tariff.rate / 100
            let interest = loans[i].remainingAmount * rate / minutesPerYear
            loans[i].remainingAmount += interest
        }
    }

    func fetchAllAccounts() async throws -> [BankAccount] {
        accounts
    }

    func fetchTransactionHistory(accountId: UUID) async throws -> [Transaction] {
        transactionsByAccount[accountId, default: []]
    }

    func fetchClients() async throws -> [Client] {
        clients
    }

    func fetchEmployees() async throws -> [User] {
        employees
    }

    func createClient(login: String, password: String, displayName: String) async throws -> Client {
        let client = Client(id: UUID(), login: login, displayName: displayName, isBlocked: false)
        clients.append(client)
        let account = BankAccount(id: UUID(), clientId: client.id, balance: 0, currency: "RUB")
        accounts.append(account)
        return client
    }

    func createEmployee(login: String, password: String, displayName: String) async throws -> User {
        let user = User(id: UUID(), login: login, displayName: displayName, isBlocked: false)
        employees.append(user)
        return user
    }

    func blockClient(id: UUID) async throws {
        if let i = clients.firstIndex(where: { $0.id == id }) {
            clients[i].isBlocked = true
        }
    }

    func unblockClient(id: UUID) async throws {
        if let i = clients.firstIndex(where: { $0.id == id }) {
            clients[i].isBlocked = false
        }
    }

    func blockEmployee(id: UUID) async throws {
        if let i = employees.firstIndex(where: { $0.id == id }) {
            employees[i].isBlocked = true
        }
    }

    func unblockEmployee(id: UUID) async throws {
        if let i = employees.firstIndex(where: { $0.id == id }) {
            employees[i].isBlocked = false
        }
    }

    func fetchLoanTariffs() async throws -> [LoanTariff] {
        tariffs
    }

    func createLoanTariff(name: String, rate: Decimal) async throws -> LoanTariff {
        let tariff = LoanTariff(id: UUID(), name: name, rate: rate)
        tariffs.append(tariff)
        return tariff
    }

    func fetchLoans(clientId: UUID) async throws -> [Loan] {
        loans.filter { $0.clientId == clientId }
    }

    func fetchLoan(id: UUID) async throws -> Loan? {
        loans.first { $0.id == id }
    }

    func fetchClient(id: UUID) async throws -> Client? {
        clients.first { $0.id == id }
    }

    func fetchTariff(id: UUID) async throws -> LoanTariff? {
        tariffs.first { $0.id == id }
    }

    func createLoan(clientId: UUID, amount: Decimal, tariffId: UUID?) async throws -> Loan {
        let loan = Loan(id: UUID(), clientId: clientId, tariffId: tariffId, totalAmount: amount, remainingAmount: amount, currency: "RUB", createdAt: Date())
        loans.append(loan)
        return loan
    }
}
