import Foundation

enum DatePrecisionName: String, Codable {
    case second = "Second"
    case minute = "Minute"
    case hour = "Hour"
    case month = "Month"
}

struct DatePrecision: Codable {
    var id: Int
    var name: DatePrecisionName
    var abbreviation: String
    var description: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case abbreviation = "abbrev"
        case description
    }
}
