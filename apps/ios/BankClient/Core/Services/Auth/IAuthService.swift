import Foundation

protocol IAuthService {
    func login(login: String, password: String) async throws
}
