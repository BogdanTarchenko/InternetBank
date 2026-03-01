import Foundation

@Observable
final class RegisterViewModel {
    var login = ""
    var password = ""
    var name = ""
    var isLoading = false
    var errorMessage: String?

    private let authService: IAuthService
    private let coordinator: IEmployeeCoordinator

    init(authService: IAuthService, coordinator: IEmployeeCoordinator) {
        self.authService = authService
        self.coordinator = coordinator
    }

    func dismiss() {
        coordinator.dismissRegisterSheet()
    }

    func submit() async {
        let errors = LoginValidator.validate(login: login, password: password)
        if !errors.isEmpty {
            errorMessage = errors.first?.message
            return
        }
        let nameTrimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if nameTrimmed.count < 2 {
            errorMessage = "Введите имя (от 2 символов)"
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            try await authService.register(login: login, password: password, name: nameTrimmed)
            coordinator.dismissRegisterSheet()
            coordinator.didLogin()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
