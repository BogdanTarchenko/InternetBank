import Foundation

protocol ICurrentUserStorage: AnyObject {
    var userId: UUID? { get set }
    func clear()
}

final class CurrentUserStorage: ICurrentUserStorage {
    private let key = "api.currentUserId"
    private let defaults = UserDefaults.standard

    var userId: UUID? {
        get {
            guard let s = defaults.string(forKey: key) else { return nil }
            return UUID(uuidString: s)
        }
        set {
            defaults.set(newValue?.uuidString, forKey: key)
        }
    }

    func clear() {
        userId = nil
    }
}
