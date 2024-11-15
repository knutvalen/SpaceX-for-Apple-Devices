struct Status: Decodable {
    let description: String?
    let name: String?

    enum CodingKeys: CodingKey {
        case description
        case name
    }
}
