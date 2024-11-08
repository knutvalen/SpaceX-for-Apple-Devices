import Foundation

struct Videos: Codable, Identifiable {
    var publisher: String?
    var type: VideoType
    var url: String
    var source: String?
    var id: String { url }
}
