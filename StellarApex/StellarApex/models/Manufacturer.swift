import Foundation

struct Manufacturer: Decodable {
    let id: Int
    let name: String
    let countries: [Country]?
    let image: ApiImage?
    let logo: ApiImage?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case countries = "country"
        case image
        case logo
    }
}
