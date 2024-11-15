import Foundation

struct ApiImage: Codable, Equatable, Hashable {
    let id: Int?
    let url: String?
    let thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case id
        case url = "image_url"
        case thumbnail = "thumbnail_url"
    }
}
