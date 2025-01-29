import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let tokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private var lastCode: String?
    private let urlSession = URLSession.shared
    
    private enum NetworkError: Error {
        case requestFailed
        case invalidResponse
        case decodingError
    }

    struct OAuthTokenResponseBody: Codable {
        let accessToken: String

        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
        }
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Проверка на гонки запросов
        if lastCode == code {
            return
        }
        lastCode = code
        
        task?.cancel()  // Отменяем предыдущий запрос, если он еще выполняется
        
        guard let request = authTokenRequest(code: code) else {
            completion(.failure(NetworkError.requestFailed))
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let tokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    let token = tokenResponse.accessToken
                    
                    self?.tokenStorage.token = token  // Сохраняем токен в Keychain
                    completion(.success(token))
                } catch {
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }
        
        self.task = task
        task.resume()
    }

    private func authTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let parameters: [String: String] = [
            "client_id": Constants.accessKey,
            "client_secret": Constants.secretKey,
            "redirect_uri": Constants.redirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]

        let bodyString = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        return request
    }
}
