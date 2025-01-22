import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var logoutButton: UIButton!

    @IBAction private func didTapLogoutButton() {
        DispatchQueue.global(qos: .userInitiated).async {
            OAuth2TokenStorage.shared.token = nil
            
            DispatchQueue.main.async {
                let alert = UIAlertController(
                    title: "Logged Out",
                    message: "You have been successfully logged out.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
