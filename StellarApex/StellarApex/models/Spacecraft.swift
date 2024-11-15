import Foundation

struct Spacecraft: Decodable {
    let name: String
    let image: ApiImage?
    let description: String?
    let flights: Int?
    let configuration: SpacecraftConfiguration?

    enum CodingKeys: String, CodingKey {
        case name
        case image
        case description
        case flights = "flights_count"
        case configuration = "spacecraft_config"
    }
}
