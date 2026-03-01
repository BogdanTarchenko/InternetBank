import Foundation

final class ApiAuthService: IAuthService {
    private let authApi: AuthApi
    private let usersApi: UsersApi
    private let currentUserStorage: ICurrentUserStorage

    init(authApi: AuthApi, usersApi: UsersApi, currentUserStorage: ICurrentUserStorage) {
        self.authApi = authApi
        self.usersApi = usersApi
        self.currentUserStorage = currentUserStorage
    }

    func login(login: String, password: String) async throws {
        _ = try await authApi.login(email: login, password: password)
        let me = try await usersApi.me()
        currentUserStorage.userId = me.id
    }

    func register(login: String, password: String, name: String) async throws {
        _ = try await authApi.register(email: login, password: password, name: name)
        let me = try await usersApi.me()
        currentUserStorage.userId = me.id
    }
}
