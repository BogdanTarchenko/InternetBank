import Foundation

struct BankAccount: Identifiable, Equatable {
    let id: UUID
    let clientId: UUID
    var balance: Decimal
    var currency: String
}
