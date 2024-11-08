import Foundation

struct Launcher: Decodable {
    let id: Int
    let serialNumber: String
    let details: String
    let successfulLandings: Int
    let attemptedLandings: Int
    let firstLaunchDate: Date?
    let lastLaunchDate: Date?
    let image: ApiImage
    let flights: Int

    enum CodingKeys: String, CodingKey {
        case id
        case serialNumber = "serial_number"
        case details
        case successfulLandings = "successful_landings"
        case attemptedLandings = "attempted_landings"
        case firstLaunchDate = "first_launch_date"
        case lastLaunchDate = "last_launch_date"
        case image
        case flights
    }
}
