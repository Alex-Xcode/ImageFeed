import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        let imagesListVC = ImagesListViewController()
        imagesListVC.tabBarItem = UITabBarItem(
            title: "Images",
            image: UIImage(systemName: "photo.on.rectangle"),
            selectedImage: UIImage(systemName: "photo.fill.on.rectangle.fill")
        )

        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        self.viewControllers = [imagesListVC, profileVC]
    }
}
