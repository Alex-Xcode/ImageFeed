import Foundation
final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()

    var token: String? {
        get {
            UserDefaults.standard.string(forKey: "OAuthToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "OAuthToken")
        }
    }

    private init() {} // Оставляем приватным, если используется `shared`
}
