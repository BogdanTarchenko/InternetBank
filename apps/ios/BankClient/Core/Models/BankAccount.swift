import Foundation

struct BankAccount: Identifiable, Equatable {
    let id: UUID
    var balance: Decimal
    var currency: String
}
