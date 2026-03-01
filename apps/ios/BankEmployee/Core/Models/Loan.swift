import Foundation

struct Loan: Identifiable, Equatable {
    let id: UUID
    let apiCreditId: Int64?
    let clientId: UUID
    let tariffId: UUID?
    let tariffName: String?
    let totalAmount: Decimal
    var remainingAmount: Decimal
    let currency: String
    let createdAt: Date
}
