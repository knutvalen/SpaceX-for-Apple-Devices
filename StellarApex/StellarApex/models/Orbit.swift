import Foundation

struct Orbit: Decodable {
    var id: Int?
    var name: String?
    var abbreviation: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case abbreviation = "abbrev"
    }
}
