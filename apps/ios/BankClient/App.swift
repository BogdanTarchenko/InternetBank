import SwiftUI

@main
struct BankClientApp: App {
    private let dependenciesAssembly = DependenciesAssembly()

    var body: some Scene {
        WindowGroup {
            dependenciesAssembly.makeRootView()
        }
    }
}
