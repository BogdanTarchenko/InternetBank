import Foundation

struct LoanTariff: Identifiable, Equatable {
    let id: UUID
    let name: String
    let rate: Decimal
}
