import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupObservers()
        fetchProfile()
    }

    private func setupUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.clipsToBounds = true
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAvatar),
            name: ProfileImageService.didChangeNotification,
            object: nil
        )
    }

    private func fetchProfile() {
        ProfileService.shared.fetchProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.updateProfileUI(with: profile)
                    ProfileImageService.shared.fetchProfileImage(username: profile.username) { _ in }
                case .failure(let error):
                    print("[ProfileService]: Ошибка \(error.localizedDescription)")
                }
            }
        }
    }

    private func updateProfileUI(with profile: Profile) {
        nameLabel.text = "\(profile.firstName) \(profile.lastName ?? "")"
        loginNameLabel.text = "@\(profile.username)"
        descriptionLabel.text = profile.bio ?? "Нет описания"
    }

    @objc private func updateAvatar(notification: Notification) {
        if let url = notification.userInfo?["url"] as? URL {
            avatarImageView.kf.setImage(with: url)
        }
    }

    @IBAction private func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Выход",
            message: "Вы уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { _ in
            self.logout()
        })
        
        present(alert, animated: true)
    }

    private func logout() {
        DispatchQueue.global(qos: .userInitiated).async {
            OAuth2TokenStorage().token = nil
            
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Выход выполнен",
                    message: "Вы успешно вышли из системы.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    self.switchToAuthScreen()
                })
                self.present(alert, animated: true)
            }
        }
    }

    private func switchToAuthScreen() {
        let authVC = AuthViewController()
        UIApplication.shared.windows.first?.rootViewController = authVC
    }
}
