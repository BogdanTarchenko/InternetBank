import Foundation

@Observable
final class LoginViewModel {
    var login = ""
    var password = ""
    var isLoading = false
    var errorMessage: String?

    private let authService: IAuthService
    private let coordinator: IBankAccountCoordinator

    init(authService: IAuthService, coordinator: IBankAccountCoordinator) {
        self.authService = authService
        self.coordinator = coordinator
    }

    func submit() async {
        let errors = LoginValidator.validate(login: login, password: password)
        if !errors.isEmpty {
            errorMessage = errors.first?.message
            return
        }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            try await authService.login(login: login, password: password)
            coordinator.didLogin()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
