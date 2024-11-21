import Foundation

struct Landing: Decodable {
    let location: Location?

    enum CodingKeys: String, CodingKey {
        case location = "landing_location"
    }
}
