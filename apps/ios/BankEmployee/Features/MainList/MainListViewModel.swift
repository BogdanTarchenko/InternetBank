import Foundation

@Observable
final class MainListViewModel {
    var accounts: [BankAccount] = []
    var clients: [Client] = []
    var employees: [User] = []
    var tariffs: [LoanTariff] = []
    var clientById: [UUID: Client] = [:]
    var isLoading = false
    var errorMessage: String?
    var isBlockingClientId: UUID?
    var isBlockingEmployeeId: UUID?

    private let employeeService: IEmployeeService
    private let coordinator: IEmployeeCoordinator

    init(employeeService: IEmployeeService, coordinator: IEmployeeCoordinator) {
        self.employeeService = employeeService
        self.coordinator = coordinator
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            async let accountsTask = employeeService.fetchAllAccounts()
            async let clientsTask = employeeService.fetchClients()
            async let employeesTask = employeeService.fetchEmployees()
            async let tariffsTask = employeeService.fetchLoanTariffs()
            let (accs, clts, emps, tfs) = try await (accountsTask, clientsTask, employeesTask, tariffsTask)
            accounts = accs
            clients = clts
            employees = emps
            tariffs = tfs
            clientById = Dictionary(uniqueKeysWithValues: clts.map { ($0.id, $0) })
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func clientDisplayName(for clientId: UUID) -> String {
        clientById[clientId]?.displayName.isEmpty == false
            ? clientById[clientId]!.displayName
            : (clientById[clientId]?.login ?? "—")
    }

    func transactionHistoryTapped(account: BankAccount) {
        coordinator.presentTransactionHistory(account: account)
    }

    func createTariffTapped() {
        coordinator.presentCreateTariff()
    }

    func createClientTapped() {
        coordinator.presentCreateClient()
    }

    func createEmployeeTapped() {
        coordinator.presentCreateEmployee()
    }

    func clientTapped(_ client: Client) {
        coordinator.presentClientLoans(client: client)
    }

    func blockClient(_ client: Client) async {
        isBlockingClientId = client.id
        errorMessage = nil
        defer { isBlockingClientId = nil }
        do {
            try await employeeService.blockClient(id: client.id)
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func unblockClient(_ client: Client) async {
        isBlockingClientId = client.id
        errorMessage = nil
        defer { isBlockingClientId = nil }
        do {
            try await employeeService.unblockClient(id: client.id)
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func blockEmployee(_ user: User) async {
        isBlockingEmployeeId = user.id
        errorMessage = nil
        defer { isBlockingEmployeeId = nil }
        do {
            try await employeeService.blockEmployee(id: user.id)
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func unblockEmployee(_ user: User) async {
        isBlockingEmployeeId = user.id
        errorMessage = nil
        defer { isBlockingEmployeeId = nil }
        do {
            try await employeeService.unblockEmployee(id: user.id)
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
