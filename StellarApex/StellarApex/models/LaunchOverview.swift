import Foundation

struct LaunchOverview: Decodable, Identifiable {
    var id: String
    var name: String
    var net: Date
    var netPrecision: DatePrecision
    var launchServiceProvider: LaunchServiceProvider

    enum CodingKeys: CodingKey {
        case id
        case name
        case net
        case netPrecision
        case launchServiceProvider
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        net = try container.decode(Date.self, forKey: .net)
        netPrecision = try container.decode(DatePrecision.self, forKey: .netPrecision)
        launchServiceProvider = try container.decode(LaunchServiceProvider.self, forKey: .launchServiceProvider)
    }
}