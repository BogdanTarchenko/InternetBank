import Foundation

final class EditProfileAssembly {
    private let usersApi: UsersApi
    private let coordinator: IBankAccountCoordinator

    init(usersApi: UsersApi, coordinator: IBankAccountCoordinator) {
        self.usersApi = usersApi
        self.coordinator = coordinator
    }

    func makeViewModel(item: EditProfileItem, onSuccess: @escaping () -> Void) -> EditProfileViewModel {
        EditProfileViewModel(
            userId: item.userId,
            name: item.name,
            email: item.email,
            usersApi: usersApi,
            coordinator: coordinator,
            onSuccess: onSuccess
        )
    }
}
