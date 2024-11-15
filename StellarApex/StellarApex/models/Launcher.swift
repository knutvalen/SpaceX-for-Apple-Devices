import Foundation

struct Launcher: Decodable {
    let id: Int?
    let serialNumber: String?
    let details: String?
    let image: ApiImage?
    let flights: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case serialNumber = "serial_number"
        case details
        case image
        case flights
    }
}
