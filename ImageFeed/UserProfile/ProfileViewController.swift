import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    var profileImageServiceObserver: NSObjectProtocol? { get set }
    func updateUserDetails(name: String, loginName: String, bio: String)
    func updateAvatar(with url: URL)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    // MARK: - Properties
    
    var presenter: ProfilePresenterProtocol?
    var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var userImageView: UIImageView = {
        let userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.tintColor = .gray
        userImageView.layer.cornerRadius = 35
        userImageView.image = UIImage(systemName: "person.crop.circle.fill")
        return userImageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.text = "Екатерина Новикова"
        userNameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        userNameLabel.textColor = .ypWhite
        return userNameLabel
    }()
    
    private lazy var userIdLabel: UILabel = {
        let userIdLabel = UILabel()
        userIdLabel.text = "@ekaterina_nov"
        userIdLabel.font = .systemFont(ofSize: 13)
        userIdLabel.textColor = .ypGray
        return userIdLabel
    }()
    
    private lazy var userDescriptionLabel: UILabel = {
        let userDescriptionLabel = UILabel()
        userDescriptionLabel.text = "Hello, world!"
        userDescriptionLabel.font = .systemFont(ofSize: 13)
        userDescriptionLabel.textColor = .ypWhite
        return userDescriptionLabel
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            userNameLabel,
            userIdLabel,
            userDescriptionLabel
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var logOutButton: UIButton = {
        let logOutButton = UIButton.systemButton(
            with: UIImage(named: "LogOut") ?? UIImage(),
            target: self,
            action: #selector(logOutButtonPressed)
        )
        logOutButton.tintColor = .ypRed
        logOutButton.accessibilityIdentifier = "logout button"
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        return logOutButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(">>> [ProfileViewController] ProfileVC did load")
        setUpScreen()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Private methods
    
    private func setUpScreen() {
        view.backgroundColor = .ypBlack
        [userImageView, labelsStackView, logOutButton].forEach { view.addSubview($0) }
        setUpConstraints()
        userImageView.layer.cornerRadius = 35
        userImageView.clipsToBounds = true
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            userImageView.widthAnchor.constraint(equalToConstant: 70),
            userImageView.heightAnchor.constraint(equalToConstant: 70),
            userImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            labelsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 110),
            labelsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8),
            
            logOutButton.widthAnchor.constraint(equalToConstant: 44),
            logOutButton.heightAnchor.constraint(equalToConstant: 44),
            logOutButton.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -14)
        ])
    }
    
    func updateUserDetails(name: String, loginName: String, bio: String) {
        userNameLabel.text = name
        userIdLabel.text = loginName
        userDescriptionLabel.text = bio
    }
    
    func updateAvatar(with url: URL) {
        print(">>> [ProfileViewController] Updating avatar...")
        userImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "person.crop.circle.fill")
        )
    }
    
    @objc private func logOutButtonPressed() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        
        let logOutAction = UIAlertAction(title: "Да", style: .default) { _ in
            ProfileLogoutService.shared.logout()
        }
        let closeAlertAction = UIAlertAction(title: "Нет", style: .default) { _ in
            self.dismiss(animated: true)
        }
        
        [logOutAction, closeAlertAction].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}
