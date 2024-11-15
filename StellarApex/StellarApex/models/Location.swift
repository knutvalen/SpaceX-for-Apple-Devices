import Foundation

struct Location: Decodable {
    let image: ApiImage?
    let description: String?
    let name: String?
    let latitude: Double?
    let longitude: Double?
}
