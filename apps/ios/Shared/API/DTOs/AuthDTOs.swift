import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct RegistrationRequest: Encodable {
    let email: String
    let password: String
    let name: String
}

struct RefreshTokenRequest: Encodable {
    let refreshToken: String
}

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
