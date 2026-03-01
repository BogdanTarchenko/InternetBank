import Foundation

protocol ITokenStorage: AnyObject {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    func clear()
}

final class TokenStorage: ITokenStorage {
    private let accessKey = "api.accessToken"
    private let refreshKey = "api.refreshToken"
    private let defaults = UserDefaults.standard

    var accessToken: String? {
        get { defaults.string(forKey: accessKey) }
        set { defaults.set(newValue, forKey: accessKey) }
    }

    var refreshToken: String? {
        get { defaults.string(forKey: refreshKey) }
        set { defaults.set(newValue, forKey: refreshKey) }
    }

    func clear() {
        accessToken = nil
        refreshToken = nil
    }
}
