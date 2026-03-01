import Foundation

protocol IAuthService {
    func login(login: String, password: String) async throws
    func register(login: String, password: String, name: String) async throws
}
