import Foundation

@Observable
final class EditProfileViewModel {
    var name: String
    var email: String
    var isSubmitting = false
    var errorMessage: String?

    private let userId: UUID
    private let usersApi: UsersApi
    private let coordinator: IBankAccountCoordinator
    private let onSuccess: () -> Void

    init(userId: UUID, name: String, email: String, usersApi: UsersApi, coordinator: IBankAccountCoordinator, onSuccess: @escaping () -> Void) {
        self.userId = userId
        self.name = name
        self.email = email
        self.usersApi = usersApi
        self.coordinator = coordinator
        self.onSuccess = onSuccess
    }

    func submit() async {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            errorMessage = "Введите email"
            return
        }
        if trimmedName.count < 2 {
            errorMessage = "Имя должно быть не короче 2 символов"
            return
        }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            _ = try await usersApi.editProfile(userId: userId, name: trimmedName, email: trimmedEmail)
            onSuccess()
            coordinator.dismissSheet()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func dismiss() {
        coordinator.dismissSheet()
    }
}
