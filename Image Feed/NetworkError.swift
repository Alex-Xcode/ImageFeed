enum NetworkError: Error {
    case invalidResponse
    case missingToken
    case decodingError
    case networkFailure(Error)
}
