import Foundation

struct EditProfileItem: Identifiable, Equatable {
    let userId: UUID
    let name: String
    let email: String

    var id: String { userId.uuidString }
}
