import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private let storage = OAuth2TokenStorage()
    private let session = URLSession.shared
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let token = storage.token else {
            completion(.failure(NetworkError.missingToken))
            return
        }

        var request = URLRequest(url: URL(string: "https://api.unsplash.com/me")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data, let profile = try? JSONDecoder().decode(Profile.self, from: data) else {
                    completion(.failure(NetworkError.decodingError))
                    return
                }
                completion(.success(profile))
            }
        }
        task.resume()
    }
}
