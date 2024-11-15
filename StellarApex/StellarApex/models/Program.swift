import Foundation

struct Program: Decodable {
    let id: Int?
    let image: ApiImage?
    let name: String?
    let description: String?
    let startDate: Date?
    let endDate: Date?
    let type: ProgramType?
    let agencies: [Agency]?

    enum CodingKeys: String, CodingKey {
        case id
        case image
        case name
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case type
        case agencies
    }
}
