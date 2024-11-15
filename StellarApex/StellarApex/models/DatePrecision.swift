import Foundation

struct DatePrecision: Codable {
    let id: Int?
    let name: DatePrecisionName?
    let abbreviation: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case abbreviation = "abbrev"
        case description
    }
}
