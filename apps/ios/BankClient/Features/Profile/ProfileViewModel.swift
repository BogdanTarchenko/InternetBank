import Foundation

@Observable
final class ProfileViewModel {
    var userId: UUID?
    var email: String = ""
    var name: String = ""
    var isLoading = false
    var errorMessage: String?

    private let usersApi: UsersApi
    private let coordinator: IBankAccountCoordinator

    init(usersApi: UsersApi, coordinator: IBankAccountCoordinator) {
        self.usersApi = usersApi
        self.coordinator = coordinator
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let user = try await usersApi.me()
            userId = user.id
            email = user.email
            name = user.name ?? ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func editTapped() {
        guard let uid = userId else { return }
        coordinator.presentEditProfile(userId: uid, name: name, email: email)
    }

    func logout() {
        coordinator.logout()
    }
}
