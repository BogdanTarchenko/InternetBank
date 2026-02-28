import Foundation

final class MockAuthService: IAuthService {
    func login(login: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}
