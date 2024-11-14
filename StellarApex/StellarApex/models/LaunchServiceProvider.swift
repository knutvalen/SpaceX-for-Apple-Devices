import Foundation

struct LaunchServiceProvider: Codable, Hashable, Comparable {
    static func < (lhs: LaunchServiceProvider, rhs: LaunchServiceProvider) -> Bool {
        return lhs.name < rhs.name
    }

    var id: Int
    var name: String
    var image: ApiImage?
    var logo: ApiImage?
    var socialLogo: ApiImage?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case logo
        case socialLogo = "social_logo"
    }
}
