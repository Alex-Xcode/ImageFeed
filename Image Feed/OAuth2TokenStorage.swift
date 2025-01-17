import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage() // Синглтон
    private init() {} // Закрытый инициализатор для предотвращения создания других экземпляров

    var token: String?
}
