struct Mission: Decodable {
    let description: String?
    let name: String?
    let orbit: Orbit?
    let type: String?
    let image: ApiImage?

    enum CodingKeys: CodingKey {
        case description
        case name
        case orbit
        case type
        case image
    }
}
