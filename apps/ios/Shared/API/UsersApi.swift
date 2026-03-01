import Foundation

final class UsersApi {
    private let client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    func me() async throws -> UserDto {
        try await client.request(path: "users/me", method: "GET")
    }

    func list(search: String? = nil, page: Int = 0, size: Int = 20) async throws -> UserPage {
        var query: [String: String] = ["page": "\(page)", "size": "\(size)"]
        if let s = search, !s.isEmpty { query["search"] = s }
        return try await client.request(path: "users", method: "GET", query: query)
    }

    func create(email: String, password: String, name: String, role: Role) async throws -> UserDto {
        let body = CreateUserRequest(email: email, password: password, name: name, role: role)
        return try await client.request(path: "users", method: "POST", body: body)
    }

    func editProfile(userId: UUID, name: String, email: String) async throws -> UserDto {
        let body = EditUserProfileRequest(name: name, email: email)
        return try await client.request(path: "users/\(userId.uuidString)", method: "PATCH", body: body)
    }

    func changeRole(userId: UUID, role: Role) async throws -> UserDto {
        let body = ChangeUserRoleRequest(userId: userId, role: role)
        return try await client.request(path: "users/\(userId.uuidString)/role", method: "PATCH", body: body)
    }
}
