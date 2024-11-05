import Foundation

struct LaunchServiceProvider: Codable, Hashable, Comparable {
    static func < (lhs: LaunchServiceProvider, rhs: LaunchServiceProvider) -> Bool {
        return lhs.name < rhs.name
    }

    var id: Int
    var name: String
    var description: String?
    var url: String?
    var logo: String?

    enum CodingKeys: CodingKey {
        case id
        case name
        case description
        case url
        case logo
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        logo = try container.decodeIfPresent(String.self, forKey: .logo)
    }
}
