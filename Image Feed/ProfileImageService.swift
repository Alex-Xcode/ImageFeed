import Foundation

final class ProfileImageService {
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    
    var avatarURL: String? {
        didSet {
            NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self)
        }
    }
    
    func fetchProfileImageURL() {
        avatarURL = "https://via.placeholder.com/100"
        //print("[ProfileImageService] URL аватарки обновлён")
    }
}
