import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ProgressHUD.animate()

        if let token = OAuth2TokenStorage().token {
            ProfileService.shared.fetchProfile { _ in
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    self.switchToMainScreen()
                }
            }
        } else {
            ProgressHUD.dismiss()
            present(AuthViewController(), animated: true)
        }
    }
    
    private func switchToMainScreen() {
        let tabBarController = TabBarController()
        UIApplication.shared.windows.first?.rootViewController = tabBarController
    }
}
