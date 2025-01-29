import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let key = "AuthToken"

    var token: String? {
        get {
            let storedToken = KeychainWrapper.standard.string(forKey: key)
            //print("[OAuth2TokenStorage] Получен токен: \(storedToken ?? "nil")")
            return storedToken
        }
        set {
            if let newToken = newValue {
                _ = KeychainWrapper.standard.set(newToken, forKey: key)
                //print("[OAuth2TokenStorage] Сохранение токена: \(isSuccess ? "Успешно" : "Ошибка")")
            } else {
                _ = KeychainWrapper.standard.removeObject(forKey: key)
                //print("[OAuth2TokenStorage] Удаление токена: \(removeSuccess ? "Успешно" : "Ошибка")")
            }
        }
    }

    func clearToken() {
        _ = KeychainWrapper.standard.removeObject(forKey: key)
        //print("[OAuth2TokenStorage] Токен удалён: \(removeSuccess ? "Успешно" : "Ошибка")") 
    }
}
