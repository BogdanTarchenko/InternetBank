import Foundation

final class AuthApi {
    private let client: ApiClient
    private let tokenStorage: ITokenStorage

    init(client: ApiClient, tokenStorage: ITokenStorage) {
        self.client = client
        self.tokenStorage = tokenStorage
    }

    func login(email: String, password: String) async throws -> AuthResponse {
        let body = LoginRequest(email: email, password: password)
        let response: AuthResponse = try await client.request(
            path: "auth/login",
            method: "POST",
            body: body,
            requiresAuth: false
        )
        tokenStorage.accessToken = response.accessToken
        tokenStorage.refreshToken = response.refreshToken
        return response
    }

    func register(email: String, password: String, name: String) async throws -> AuthResponse {
        let body = RegistrationRequest(email: email, password: password, name: name)
        let response: AuthResponse = try await client.request(
            path: "auth/register",
            method: "POST",
            body: body,
            requiresAuth: false
        )
        tokenStorage.accessToken = response.accessToken
        tokenStorage.refreshToken = response.refreshToken
        return response
    }

    func refresh() async throws {
        guard let refreshToken = tokenStorage.refreshToken else { throw ApiError.unauthorized }
        let body = RefreshTokenRequest(refreshToken: refreshToken)
        let response: AuthResponse = try await client.request(
            path: "auth/refresh",
            method: "POST",
            body: body,
            requiresAuth: false
        )
        tokenStorage.accessToken = response.accessToken
        tokenStorage.refreshToken = response.refreshToken
    }
}
