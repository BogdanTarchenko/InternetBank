import Foundation

enum Role: String, Codable {
    case CLIENT
    case EMPLOYEE
    case ADMIN
    case BANNED
}

struct UserDto: Decodable {
    let id: UUID
    let email: String
    let name: String?
    let role: Role
}

struct CreateUserRequest: Encodable {
    let email: String
    let password: String
    let name: String
    let role: Role
}

struct EditUserProfileRequest: Encodable {
    let name: String
    let email: String
}

struct ChangeUserRoleRequest: Encodable {
    let userId: UUID
    let role: Role
}

struct UserPage: Decodable {
    let content: [UserDto]
    let totalElements: Int
    let totalPages: Int
    let size: Int
    let number: Int
    let first: Bool
    let last: Bool
}
