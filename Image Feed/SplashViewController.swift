import UIKit

final class SplashViewController: UIViewController {
    private let oauth2TokenStorage = OAuth2TokenStorage.shared // Используем синглтон
    private let showAuthSegue = "ShowAuthSegue"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuth()
    }

    private func checkAuth() {
        if oauth2TokenStorage.token != nil {
            switchToMainScreen()
        } else {
            performSegue(withIdentifier: showAuthSegue, sender: nil)
        }
    }

    private func switchToMainScreen() {
        guard let window = UIApplication.shared.windows.first else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        window.rootViewController = tabBarVC
        window.makeKeyAndVisible()
    }
}
