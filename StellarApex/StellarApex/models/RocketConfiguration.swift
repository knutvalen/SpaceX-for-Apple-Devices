import Foundation

struct RocketConfiguration: Decodable {
    let id: Int?
    let name: String?
    let fullName: String?
    let description: String?
    let manufacturer: Manufacturer?
    let image: ApiImage?
    let length: Double?
    let diameter: Double?
    let launchCost: Int?
    let thrustAtLiftOff: Int?
    let reusable: Bool?
    let programs: [Program]?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case manufacturer
        case image
        case length
        case diameter
        case launchCost = "launch_cost"
        case thrustAtLiftOff = "to_thrust"
        case fullName = "full_name"
        case reusable
        case programs = "program"
    }
}
