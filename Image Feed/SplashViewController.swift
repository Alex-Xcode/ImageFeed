import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splash_screen_logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        checkAuth()
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func checkAuth() {
        if KeychainWrapper.standard.string(forKey: "AuthToken") != nil {
            //print("[Splash] Токен найден, переходим в приложение")
            openMainScreen()
        } else {
            //print("[Splash] Токен не найден, показываем экран авторизации") 
            present(AuthViewController(), animated: true)
        }
    }
    
    private func openMainScreen() {
        let tabBarVC = TabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
}
