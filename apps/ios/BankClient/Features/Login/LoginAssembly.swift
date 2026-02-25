import Foundation

final class LoginAssembly {
    private let authService: IAuthService
    private let coordinator: IBankAccountCoordinator

    init(authService: IAuthService, coordinator: IBankAccountCoordinator) {
        self.authService = authService
        self.coordinator = coordinator
    }

    func makeViewModel() -> LoginViewModel {
        LoginViewModel(authService: authService, coordinator: coordinator)
    }
}
