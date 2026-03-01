import Foundation

struct LoanTariff: Identifiable, Equatable {
    let id: Int64
    let name: String
    let interestRate: Decimal
}
