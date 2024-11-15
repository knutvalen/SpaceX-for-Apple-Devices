import Foundation

struct Agency: Decodable, Hashable {
    let id: Int?
    let name: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageURL = "image_url"
    }
}
