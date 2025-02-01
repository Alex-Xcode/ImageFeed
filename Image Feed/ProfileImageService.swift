import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private let storage = OAuth2TokenStorage()
    private let session = URLSession.shared
    static let didChangeNotification = Notification.Name("ProfileImageServiceDidChange")
    
    func fetchProfileImage(username: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let token = storage.token else {
            completion(.failure(NetworkError.missingToken))
            return
        }

        let urlString = "https://api.unsplash.com/users/\(username)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(NetworkError.networkFailure(error)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }

                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    guard let imageUrl = URL(string: user.profileImage.large) else {
                        completion(.failure(NetworkError.invalidResponse))
                        return
                    }
                    
                    NotificationCenter.default.post(name: Self.didChangeNotification, object: self, userInfo: ["url": imageUrl])
                    completion(.success(imageUrl))
                    
                } catch {
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }
        task.resume()
    }
}
