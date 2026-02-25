import Foundation

enum TransactionType: String, Equatable {
    case deposit
    case withdrawal
}

struct Transaction: Identifiable, Equatable {
    let id: UUID
    let accountId: UUID
    let type: TransactionType
    let amount: Decimal
    let date: Date
}
