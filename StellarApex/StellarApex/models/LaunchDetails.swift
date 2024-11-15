import Foundation

struct LaunchDetails: Decodable {
    let id: String?
    let lastUpdated: Date?
    let mission: Mission?
    let name: String?
    let net: Date?
    let netPrecision: DatePrecision?
    let patches: [MissionPatch]?
    let status: Status?
    let videos: [Videos]?
    let rocket: Rocket?
    let image: ApiImage?
    let programs: [Program]?
    let launchServiceProvider: LaunchServiceProvider?
    let pad: Pad?

    enum CodingKeys: String, CodingKey {
        case id
        case lastUpdated = "last_updated"
        case mission
        case name
        case net
        case netPrecision = "net_precision"
        case patches = "mission_patches"
        case status
        case videos = "vid_urls"
        case rocket
        case image
        case programs = "program"
        case launchServiceProvider = "launch_service_provider"
        case pad
    }
}
