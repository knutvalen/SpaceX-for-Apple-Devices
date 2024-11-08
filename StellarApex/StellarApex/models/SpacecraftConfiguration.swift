import Foundation

struct SpacecraftConfiguration: Decodable {
    let diameter: Double?
    let length: Double?
    let payloadCapacity: Int?

    enum CodingKeys: String, CodingKey {
        case diameter
        case length = "height"
        case payloadCapacity = "payload_capacity"
    }
}
