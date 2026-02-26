import Foundation

struct Client: Identifiable, Equatable {
    let id: UUID
    let login: String
    var displayName: String
    var isBlocked: Bool
}
