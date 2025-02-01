import Foundation
import ProgressHUD

final class OAuthService {
    static let shared = OAuthService()
    
    private var currentTask: URLSessionDataTask?
    private let session = URLSession.shared
    private let storage = OAuth2TokenStorage()
    
    func fetchOAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        currentTask?.cancel()
        ProgressHUD.animate()

        let request = makeAuthRequest(with: code)
        currentTask = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data, let token = self.parseToken(from: data) else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                self.storage.token = token
                completion(.success(token))
            }
        }
        currentTask?.resume()
    }

    private func makeAuthRequest(with code: String) -> URLRequest {
        let urlString = "https://unsplash.com/oauth/token"
        var components = URLComponents(string: urlString)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: "urn:ietf:wg:oauth:2.0:oob"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }

    private func parseToken(from data: Data) -> String? {
        struct Response: Codable {
            let access_token: String
        }
        
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(Response.self, from: data)
            return response.access_token
        } catch {
            print("[OAuthService]: Ошибка декодирования токена - \(error)")
            return nil
        }
    }
}
