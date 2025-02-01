import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let imagesListVC = ImagesListViewController()
        imagesListVC.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "photo.on.rectangle"),
            selectedImage: UIImage(systemName: "photo.on.rectangle.fill")
        )

        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person.crop.circle"),
            selectedImage: UIImage(systemName: "person.crop.circle.fill")
        )

        viewControllers = [imagesListVC, profileVC]
    }
}
