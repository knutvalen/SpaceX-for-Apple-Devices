import Foundation

struct MissionPatch: Decodable {
    var id: Int
    var imageURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
    }
}
