import Foundation

final class LoginAssembly {
    private let authService: IAuthService
    private let coordinator: IEmployeeCoordinator

    init(authService: IAuthService, coordinator: IEmployeeCoordinator) {
        self.authService = authService
        self.coordinator = coordinator
    }

    func makeViewModel() -> LoginViewModel {
        LoginViewModel(authService: authService, coordinator: coordinator)
    }
}
