struct Mission: Decodable {
    var description: String?
    var name: String
    var orbit: Orbit
    var type: String
//    var image: ApiImage

    enum CodingKeys: CodingKey {
        case description
        case name
        case orbit
        case type
//        case image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        name = try container.decode(String.self, forKey: .name)
        orbit = try container.decode(Orbit.self, forKey: .orbit)
        type = try container.decode(String.self, forKey: .type)
//        image = try container.decode(ApiImage.self, forKey: .image)
    }
}
