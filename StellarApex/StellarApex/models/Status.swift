struct Status: Decodable {
    var description: String
    var name: String

    enum CodingKeys: CodingKey {
        case description
        case name
    }
}
