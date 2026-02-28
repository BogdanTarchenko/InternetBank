import Foundation

struct Loan: Identifiable, Equatable {
    let id: UUID
    let clientId: UUID
    let tariffId: UUID?
    let totalAmount: Decimal
    var remainingAmount: Decimal
    let currency: String
    let createdAt: Date
}
