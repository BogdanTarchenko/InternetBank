import Foundation

struct Loan: Identifiable, Equatable {
    let id: UUID
    let apiCreditId: Int64?
    let tariffName: String
    let interestRate: Decimal
    let totalAmount: Decimal
    var remainingAmount: Decimal
    let currency: String
    let isClosed: Bool
}
