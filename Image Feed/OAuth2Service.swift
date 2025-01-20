import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
}

final class OAuth2Service {
    static let shared = OAuth2Service() // Синглтон
    
    private init() {}
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: Constants.TokenURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: String] = [
            "client_id": Constants.AccessKey,
            "client_secret": Constants.SecretKey,
            "redirect_uri": Constants.RedirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        request.httpBody = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                do {
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(tokenResponse.access_token))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
