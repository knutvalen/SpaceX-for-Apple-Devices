import Foundation

struct LaunchDetails: Decodable {
    var id: String?
    var lastUpdated: Date?
    var mission: Mission?
    var name: String?
    var net: Date?
    var netPrecision: DatePrecision?
    var patches: [MissionPatch]?
    var status: Status?
    var videos: [Videos]?
    var rocket: Rocket?
    var image: ApiImage?
    var program: [Program]?
    var launchServiceProvider: LaunchServiceProvider?

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
        case program
        case launchServiceProvider = "launch_service_provider"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        lastUpdated = try container.decode(Date.self, forKey: .lastUpdated)
        mission = try container.decode(Mission.self, forKey: .mission)
        name = try container.decode(String.self, forKey: .name)
        net = try container.decode(Date.self, forKey: .net)
        netPrecision = try container.decode(DatePrecision.self, forKey: .netPrecision)
        patches = try container.decode([MissionPatch].self, forKey: .patches)
        status = try container.decode(Status.self, forKey: .status)
        videos = try container.decode([Videos].self, forKey: .videos)
        rocket = try container.decode(Rocket.self, forKey: .rocket)
        image = try container.decode(ApiImage.self, forKey: .image)
        program = try container.decode([Program].self, forKey: .program)
        launchServiceProvider = try container.decode(LaunchServiceProvider.self, forKey: .launchServiceProvider)
    }
}
