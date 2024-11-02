import Foundation

struct NewsArticle: Decodable, Identifiable {
    var id: Int
    var title: String
    var newsUrl: URL
    var imageUrl: URL
    var newsSite: String
    var summary: String
    var publishedAt: Date
    var updatedAt: Date
    var featured: Bool?
    var launches: [String]

    enum CodingKeys: CodingKey {
        case id
        case title
        case newsUrl
        case imageUrl
        case newsSite
        case summary
        case publishedAt
        case updatedAt
        case featured
        case launches
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)

        let newsUrlString = try container.decode(String.self, forKey: .newsUrl)

        guard let newsUrl = URL(string: newsUrlString) else {
            throw DecodingError.dataCorruptedError(forKey: .newsUrl, in: container, debugDescription: "newsUrl is invalid")
        }

        self.newsUrl = newsUrl

        let imageUrlString = try container.decode(String.self, forKey: .imageUrl)

        guard let imageUrl = URL(string: imageUrlString) else {
            throw DecodingError.dataCorruptedError(forKey: .imageUrl, in: container, debugDescription: "imageUrl is invalid")
        }

        self.imageUrl = imageUrl

        newsSite = try container.decode(String.self, forKey: .newsSite)
        summary = try container.decode(String.self, forKey: .summary)
        publishedAt = try container.decode(Date.self, forKey: .publishedAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        featured = try container.decodeIfPresent(Bool.self, forKey: .featured)
        launches = try container.decode([String].self, forKey: .launches)
    }
}
