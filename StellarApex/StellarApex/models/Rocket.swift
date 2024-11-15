import Foundation

struct Rocket: Decodable {
    let id: Int?
    let configuration: RocketConfiguration?
    let launcherStage: [FirstStage]?
    let spacecraftStage: [SecondStage]?

    enum CodingKeys: String, CodingKey {
        case id
        case configuration
        case launcherStage = "launcher_stage"
        case spacecraftStage = "spacecraft_stage"
    }
}
