import Foundation

struct User: Codable {
    struct ProfileImage: Codable {
        let large: String
    }
    
    let username: String
    let profileImage: ProfileImage
}
