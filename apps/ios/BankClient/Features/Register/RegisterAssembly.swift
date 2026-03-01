import Foundation

final class RegisterAssembly {
    private let authService: IAuthService
    private let coordinator: IBankAccountCoordinator

    init(authService: IAuthService, coordinator: IBankAccountCoordinator) {
        self.authService = authService
        self.coordinator = coordinator
    }

    func makeViewModel() -> RegisterViewModel {
        RegisterViewModel(authService: authService, coordinator: coordinator)
    }
}
