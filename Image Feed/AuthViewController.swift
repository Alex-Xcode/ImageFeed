import UIKit
import SwiftKeychainWrapper

final class AuthViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        login()
    }

    private func login() {
        let success = KeychainWrapper.standard.set("mockAuthToken", forKey: "AuthToken")
        if success {
            //print("[Auth] Токен сохранён")
        } else {
            //print("[Auth] Ошибка сохранения токена")
        }
        
        dismiss(animated: true)
    }
}
