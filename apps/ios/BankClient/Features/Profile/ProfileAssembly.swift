import Foundation

final class ProfileAssembly {
    private let usersApi: UsersApi
    private let coordinator: IBankAccountCoordinator

    init(usersApi: UsersApi, coordinator: IBankAccountCoordinator) {
        self.usersApi = usersApi
        self.coordinator = coordinator
    }

    func makeViewModel() -> ProfileViewModel {
        ProfileViewModel(
            usersApi: usersApi,
            coordinator: coordinator
        )
    }
}
