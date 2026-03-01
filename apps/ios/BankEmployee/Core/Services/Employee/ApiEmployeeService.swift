import Foundation

final class ApiEmployeeService: IEmployeeService {
    private let client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    private func uuidFromCreditId(_ id: Int64) -> UUID {
        UUID(uuidString: "00000000-0000-0000-0000-" + String(format: "%012llx", UInt64(bitPattern: id)))!
    }

    private func uuidFromTariffId(_ id: Int64) -> UUID {
        UUID(uuidString: "00000000-0000-0000-0001-" + String(format: "%012llx", UInt64(bitPattern: id)))!
    }

    func fetchAllAccounts() async throws -> [BankAccount] {
        let list: [AccountResponse] = try await client.request(path: "core/employee/accounts", method: "GET")
        return list.map { a in
            let clientId = UUID(uuidString: a.userId) ?? UUID()
            return BankAccount(id: a.id, clientId: clientId, balance: a.balance, currency: "RUB")
        }
    }

    func fetchTransactionHistory(accountId: UUID) async throws -> [Transaction] {
        let list: [OperationResponse] = try await client.request(
            path: "core/employee/accounts/\(accountId.uuidString)/operations",
            method: "GET"
        )
        return list.compactMap { op in
            let type: TransactionType? = op.type == .DEPOSIT ? .deposit : (op.type == .WITHDRAW ? .withdrawal : nil)
            guard let t = type else { return nil }
            return Transaction(id: op.id, accountId: op.accountId, type: t, amount: op.amount, date: op.createdAt)
        }
    }

    func fetchClients() async throws -> [Client] {
        let page: UserPage = try await client.request(path: "users", method: "GET", query: ["size": "500"])
        return page.content
            .filter { $0.role == .CLIENT || $0.role == .BANNED }
            .map { u in
                Client(
                    id: u.id,
                    login: u.email,
                    displayName: u.name ?? "",
                    isBlocked: u.role == .BANNED
                )
            }
    }

    func fetchEmployees() async throws -> [User] {
        let page: UserPage = try await client.request(path: "users", method: "GET", query: ["size": "500"])
        return page.content
            .filter { $0.role == .EMPLOYEE || $0.role == .ADMIN || $0.role == .BANNED }
            .map { u in
                User(
                    id: u.id,
                    login: u.email,
                    displayName: u.name ?? "",
                    isBlocked: u.role == .BANNED
                )
            }
    }

    func createClient(login: String, password: String, displayName: String) async throws -> Client {
        let body = CreateUserRequest(email: login, password: password, name: displayName, role: .CLIENT)
        let u: UserDto = try await client.request(path: "users", method: "POST", body: body)
        return Client(id: u.id, login: u.email, displayName: u.name ?? "", isBlocked: false)
    }

    func createEmployee(login: String, password: String, displayName: String) async throws -> User {
        let body = CreateUserRequest(email: login, password: password, name: displayName, role: .EMPLOYEE)
        let u: UserDto = try await client.request(path: "users", method: "POST", body: body)
        return User(id: u.id, login: u.email, displayName: u.name ?? "", isBlocked: false)
    }

    func blockClient(id: UUID) async throws {
        _ = try await client.request(path: "users/\(id.uuidString)/role", method: "PATCH", body: ChangeUserRoleRequest(userId: id, role: .BANNED)) as UserDto
    }

    func unblockClient(id: UUID) async throws {
        _ = try await client.request(path: "users/\(id.uuidString)/role", method: "PATCH", body: ChangeUserRoleRequest(userId: id, role: .CLIENT)) as UserDto
    }

    func blockEmployee(id: UUID) async throws {
        _ = try await client.request(path: "users/\(id.uuidString)/role", method: "PATCH", body: ChangeUserRoleRequest(userId: id, role: .BANNED)) as UserDto
    }

    func unblockEmployee(id: UUID) async throws {
        _ = try await client.request(path: "users/\(id.uuidString)/role", method: "PATCH", body: ChangeUserRoleRequest(userId: id, role: .EMPLOYEE)) as UserDto
    }

    func fetchLoanTariffs() async throws -> [LoanTariff] {
        let list: [TariffResponse] = try await client.request(path: "credit/employee/tariffs", method: "GET")
        return list.map { t in
            LoanTariff(id: uuidFromTariffId(t.id), name: t.name, rate: t.interestRate)
        }
    }

    func createLoanTariff(name: String, rate: Decimal) async throws -> LoanTariff {
        let body = CreateTariffRequest(name: name, interestRate: rate, paymentIntervalMinutes: 1)
        let t: TariffResponse = try await client.request(path: "credit/employee/tariffs", method: "POST", body: body)
        return LoanTariff(id: uuidFromTariffId(t.id), name: t.name, rate: t.interestRate)
    }

    func fetchLoans(clientId: UUID) async throws -> [Loan] {
        let list: [CreditResponse] = try await client.request(
            path: "credit/employee/clients/\(clientId.uuidString)/credits",
            method: "GET"
        )
        return list.map { c in
            let clientUid = UUID(uuidString: c.userId) ?? UUID()
            let started = c.startedAt ?? Date()
            return Loan(
                id: uuidFromCreditId(c.id),
                apiCreditId: c.id,
                clientId: clientUid,
                tariffId: nil,
                tariffName: c.tariffName,
                totalAmount: c.totalAmount,
                remainingAmount: c.remainingAmount,
                currency: "RUB",
                createdAt: started
            )
        }
    }

    func fetchLoanDetail(creditId: Int64) async throws -> Loan? {
        let detail: CreditDetailResponse = try await client.request(
            path: "credit/employee/credits/\(creditId)",
            method: "GET"
        )
        let c = detail.credit
        let clientUid = UUID(uuidString: c.userId) ?? UUID()
        let started = c.startedAt ?? Date()
        return Loan(
            id: uuidFromCreditId(c.id),
            apiCreditId: c.id,
            clientId: clientUid,
            tariffId: nil,
            tariffName: c.tariffName,
            totalAmount: c.totalAmount,
            remainingAmount: c.remainingAmount,
            currency: "RUB",
            createdAt: started
        )
    }

    func fetchClient(id: UUID) async throws -> Client? {
        let page: UserPage = try await client.request(path: "users", method: "GET", query: ["size": "500"])
        return page.content.first { $0.id == id }.map { u in
            Client(id: u.id, login: u.email, displayName: u.name ?? "", isBlocked: u.role == .BANNED)
        }
    }

    func fetchTariff(id: UUID) async throws -> LoanTariff? {
        let list: [TariffResponse] = try await client.request(path: "credit/employee/tariffs", method: "GET")
        guard let t = list.first(where: { uuidFromTariffId($0.id) == id }) else { return nil }
        return LoanTariff(id: uuidFromTariffId(t.id), name: t.name, rate: t.interestRate)
    }

    func createLoan(clientId: UUID, amount: Decimal, tariffId: UUID?) async throws -> Loan {
        throw NSError(domain: "ApiEmployeeService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Оформление кредита доступно в приложении клиента"])
    }
}
