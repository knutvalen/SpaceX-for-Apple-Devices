import Foundation

struct LaunchServiceProvider: Codable, Hashable, Comparable {
    static func < (lhs: LaunchServiceProvider, rhs: LaunchServiceProvider) -> Bool {
        return lhs.name < rhs.name
    }

    let id: Int
    let name: String
    let image: ApiImage?
    let logo: ApiImage?
    let socialLogo: ApiImage?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case logo
        case socialLogo = "social_logo"
    }
}
