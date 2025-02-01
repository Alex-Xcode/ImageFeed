import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let key = "accessToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: key)
        }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: key)
            } else {
                KeychainWrapper.standard.removeObject(forKey: key)
            }
        }
    }
}
