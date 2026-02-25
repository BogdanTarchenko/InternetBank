import Foundation

struct Loan: Identifiable, Equatable {
    let id: UUID
    let totalAmount: Decimal
    var remainingAmount: Decimal
    let currency: String
}
