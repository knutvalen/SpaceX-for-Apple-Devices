import Foundation

struct ApiImage: Codable, Equatable, Hashable {
    var id: Int
    var url: String
    var thumbnail: String

    enum CodingKeys: String, CodingKey {
        case id
        case url = "image_url"
        case thumbnail = "thumbnail_url"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        url = try container.decode(String.self, forKey: .url)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
    }
}
