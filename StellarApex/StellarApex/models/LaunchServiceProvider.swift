import Foundation

struct LaunchServiceProvider: Codable, Hashable, Comparable {
    static func < (lhs: LaunchServiceProvider, rhs: LaunchServiceProvider) -> Bool {
        return lhs.name < rhs.name
    }

    var id: Int
    var name: String
    var url: String?

    enum CodingKeys: CodingKey {
        case id
        case name
        case url
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decodeIfPresent(String.self, forKey: .url)
    }
}
