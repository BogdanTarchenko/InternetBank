import Foundation

final class ApiBankAccountService: IBankAccountService {
    private let client: ApiClient
    private let currentUserStorage: ICurrentUserStorage

    init(client: ApiClient, currentUserStorage: ICurrentUserStorage) {
        self.client = client
        self.currentUserStorage = currentUserStorage
    }

    private func userId() throws -> UUID {
        guard let id = currentUserStorage.userId else { throw ApiError.unauthorized }
        return id
    }

    func fetchAccounts() async throws -> [BankAccount] {
        let uid = try userId()
        let list: [AccountResponse] = try await client.request(
            path: "core/client/accounts",
            method: "GET",
            query: ["userId": uid.uuidString]
        )
        return list
            .filter { $0.status == .ACTIVE }
            .map { a in
                BankAccount(
                    id: a.id,
                    balance: a.balance,
                    currency: "RUB"
                )
            }
    }

    func openAccount() async throws -> BankAccount {
        let uid = try userId()
        let body = OpenAccountRequest(userId: uid)
        let a: AccountResponse = try await client.request(
            path: "core/client/accounts",
            method: "POST",
            body: body
        )
        return BankAccount(id: a.id, balance: a.balance, currency: "RUB")
    }

    func closeAccount(id: UUID) async throws {
        let uid = try userId()
        _ = try await client.requestVoid(
            path: "core/client/accounts/\(id.uuidString)",
            method: "DELETE",
            query: ["userId": uid.uuidString]
        )
    }

    func deposit(accountId: UUID, amount: Decimal) async throws {
        let uid = try userId()
        let body = MoneyRequest(amount: amount)
        _ = try await client.requestVoid(
            path: "core/client/accounts/\(accountId.uuidString)/deposit",
            method: "POST",
            query: ["userId": uid.uuidString],
            body: body
        )
    }

    func withdraw(accountId: UUID, amount: Decimal) async throws {
        let uid = try userId()
        let body = MoneyRequest(amount: amount)
        _ = try await client.requestVoid(
            path: "core/client/accounts/\(accountId.uuidString)/withdraw",
            method: "POST",
            query: ["userId": uid.uuidString],
            body: body
        )
    }

    func fetchTransactionHistory(accountId: UUID) async throws -> [Transaction] {
        let uid = try userId()
        let list: [OperationResponse] = try await client.request(
            path: "core/client/accounts/\(accountId.uuidString)/operations",
            method: "GET",
            query: ["userId": uid.uuidString]
        )
        return list.compactMap { op in
            let type: TransactionType? = op.type == .DEPOSIT ? .deposit : (op.type == .WITHDRAW ? .withdrawal : nil)
            guard let t = type else { return nil }
            return Transaction(id: op.id, accountId: op.accountId, type: t, amount: op.amount, date: op.createdAt)
        }
    }

    func fetchLoans() async throws -> [Loan] {
        let uid = try userId()
        let list: [CreditResponse] = try await client.request(
            path: "credit/client/credits",
            method: "GET",
            query: ["userId": uid.uuidString]
        )
        return list.map { c in
            Loan(
                id: UUID(uuidString: "00000000-0000-0000-0000-" + String(format: "%012llx", UInt64(bitPattern: c.id)))!,
                apiCreditId: c.id,
                tariffName: c.tariffName ?? "",
                interestRate: c.interestRate ?? 0,
                totalAmount: c.totalAmount,
                remainingAmount: c.remainingAmount,
                currency: "RUB",
                isClosed: (c.status?.uppercased() == "CLOSED") || c.remainingAmount <= 0
            )
        }
    }

    func fetchTariffs() async throws -> [LoanTariff] {
        let list: [TariffResponse] = try await client.request(path: "credit/client/tariffs", method: "GET")
        return list.map { LoanTariff(id: $0.id, name: $0.name, interestRate: $0.interestRate) }
    }

    func takeLoan(amount: Decimal, accountId: UUID, tariffId: Int64) async throws -> Loan {
        let uid = try userId()
        let body = TakeCreditRequest(userId: uid, tariffId: tariffId, amount: amount, accountId: accountId)
        let c: CreditResponse = try await client.request(path: "credit/client/credits", method: "POST", body: body)
        return Loan(
            id: UUID(uuidString: "00000000-0000-0000-0000-" + String(format: "%012llx", UInt64(bitPattern: c.id)))!,
            apiCreditId: c.id,
            tariffName: c.tariffName ?? "",
            interestRate: c.interestRate ?? 0,
            totalAmount: c.totalAmount,
            remainingAmount: c.remainingAmount,
            currency: "RUB",
            isClosed: false
        )
    }

    func repayLoan(loan: Loan, amount: Decimal, accountId: UUID) async throws {
        let uid = try userId()
        guard let creditId = loan.apiCreditId else {
            throw NSError(domain: "ApiBankAccountService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Кредит не найден"])
        }
        let body = RepayRequest(accountId: accountId, amount: amount)
        _ = try await client.requestVoid(
            path: "credit/client/credits/\(creditId)/repay",
            method: "POST",
            query: ["userId": uid.uuidString],
            body: body
        )
    }
}
