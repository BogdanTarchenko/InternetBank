import Foundation

final class RegisterAssembly {
    private let authService: IAuthService
    private let coordinator: IEmployeeCoordinator

    init(authService: IAuthService, coordinator: IEmployeeCoordinator) {
        self.authService = authService
        self.coordinator = coordinator
    }

    func makeViewModel() -> RegisterViewModel {
        RegisterViewModel(authService: authService, coordinator: coordinator)
    }
}
