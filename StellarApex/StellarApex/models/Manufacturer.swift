import Foundation

struct Manufacturer: Decodable {
    let id: Int
    let name: String
    var image: ApiImage?
    var logo: ApiImage?
}
