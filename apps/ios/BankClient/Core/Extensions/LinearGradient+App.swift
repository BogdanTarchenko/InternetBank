import SwiftUI

extension LinearGradient {
    static var appAccent: LinearGradient {
        LinearGradient(
            colors: [Colors.start, Colors.end],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private extension LinearGradient {
    enum Colors {
        static let start = Color(red: 0.22, green: 0.58, blue: 0.65)
        static let end = Color(red: 0.18, green: 0.42, blue: 0.55)
    }
}
