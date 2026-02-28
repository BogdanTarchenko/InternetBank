import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    let login: String
    var displayName: String
    var isBlocked: Bool
}
