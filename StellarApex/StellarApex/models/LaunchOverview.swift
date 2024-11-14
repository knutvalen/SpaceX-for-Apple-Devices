import Foundation

struct LaunchOverview: Decodable, Identifiable {
    var id: String
    var name: String
    var net: Date
    var netPrecision: DatePrecision
    var launchServiceProvider: LaunchServiceProvider

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case net
        case netPrecision = "net_precision"
        case launchServiceProvider = "launch_service_provider"
    }
}
