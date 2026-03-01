import Foundation

struct CreateTariffRequest: Encodable {
    let name: String
    let interestRate: Decimal
    let paymentIntervalMinutes: Int
}

struct TariffResponse: Decodable {
    let id: Int64
    let name: String
    let interestRate: Decimal
    let paymentIntervalMinutes: Int
}

struct TakeCreditRequest: Encodable {
    let userId: UUID
    let tariffId: Int64
    let amount: Decimal
    let accountId: UUID
}

struct RepayRequest: Encodable {
    let accountId: UUID
    let amount: Decimal
}

struct CreditResponse: Decodable {
    let id: Int64
    let userId: String
    let tariffId: Int64
    let tariffName: String?
    let interestRate: Decimal?
    let totalAmount: Decimal
    let remainingAmount: Decimal
    let status: String?
    let startedAt: Date?
    let nextPaymentAt: Date?
}

struct CreditPaymentResponse: Decodable {
    let id: Int64
    let paidAt: Date
    let amount: Decimal
}

struct CreditDetailResponse: Decodable {
    let credit: CreditResponse
    let payments: [CreditPaymentResponse]
}
