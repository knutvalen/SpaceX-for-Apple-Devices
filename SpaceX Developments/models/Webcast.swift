import Foundation

struct Webcast: Codable, Identifiable {
    var publisher: String?
    var type: WebcastType
    var url: String

    var id: String { url }
}
