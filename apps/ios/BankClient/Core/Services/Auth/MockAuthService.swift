import Foundation

final class MockAuthService: IAuthService {
    func login(login: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 2_000_000_000)
    }
}
