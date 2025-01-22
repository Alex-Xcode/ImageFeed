import UIKit

final class SplashViewController: UIViewController {
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let showAuthSegueIdentifier = "ShowAuthSegue"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuth()
    }

    private func checkAuth() {
        if let token = oauth2TokenStorage.token, !token.isEmpty {
            switchToMainScreen()
        } else {
            performSegue(withIdentifier: showAuthSegueIdentifier, sender: nil)
        }
    }

    private func switchToMainScreen() {
        guard let window = UIApplication.shared.windows.first else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        window.rootViewController = tabBarVC
        window.makeKeyAndVisible()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthSegueIdentifier,
           let navController = segue.destination as? UINavigationController,
           let authVC = navController.viewControllers.first as? AuthViewController {
            authVC.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            self?.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        let oauth2Service = OAuth2Service.shared
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            switch result {
            case .success:
                self?.switchToMainScreen()
            case .failure(let error):
                print("Error fetching token: \(error)")
            }
        }
    }
}

