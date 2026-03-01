import Foundation

struct OpenAccountRequest: Encodable {
    let userId: UUID
}

struct MoneyRequest: Encodable {
    let amount: Decimal
}

enum AccountStatus: String, Codable {
    case ACTIVE
    case CLOSED
}

struct AccountResponse: Decodable {
    let id: UUID
    let userId: String
    let balance: Decimal
    let status: AccountStatus
    let createdAt: String
    let updatedAt: String
}

enum OperationType: String, Codable {
    case OPEN_ACCOUNT
    case CLOSE_ACCOUNT
    case DEPOSIT
    case WITHDRAW
}

struct OperationResponse: Decodable {
    let id: UUID
    let accountId: UUID
    let type: OperationType
    let amount: Decimal
    let balanceAfter: Decimal?
    let createdAt: Date
}
