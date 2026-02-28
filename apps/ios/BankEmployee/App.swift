import SwiftUI

@main
struct BankEmployeeApp: App {
    private let dependenciesAssembly = DependenciesAssembly()

    var body: some Scene {
        WindowGroup {
            dependenciesAssembly.makeRootView()
        }
    }
}
