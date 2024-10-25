import Foundation

struct Endpoint {
    let host: String
    let version: String
    let path: String
    let queryItems: [URLQueryItem]
    static let launchServiceProvider = "SpaceX"

    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/\(version)/\(path)"
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

    static func launchDetails(for launchId: String) -> Endpoint {
        return Endpoint(
            host: buildConfiguration == .development ? "lldev.thespacedevs.com" : "ll.thespacedevs.com",
            version: "2.3.0",
            path: "launches/\(launchId)",
            queryItems: [URLQueryItem(name: "mode", value: DetailMode.normal.rawValue)]
        )
    }

    static func nextLaunch() -> Endpoint {
        return Endpoint(
            host: buildConfiguration == .development ? "lldev.thespacedevs.com" : "ll.thespacedevs.com",
            version: "2.3.0",
            path: "launches/upcoming",
            queryItems: [
                URLQueryItem(name: "lsp__name", value: launchServiceProvider),
                URLQueryItem(name: "related", value: true.description),
                URLQueryItem(name: "mode", value: DetailMode.normal.rawValue),
                URLQueryItem(name: "limit", value: 1.description),
            ]
        )
    }

    static func previousLaunches(limit: Int) -> Endpoint {
        return Endpoint(
            host: buildConfiguration == .development ? "lldev.thespacedevs.com" : "ll.thespacedevs.com",
            version: "2.3.0",
            path: "launches/previous",
            queryItems: [
                URLQueryItem(name: "lsp__name", value: launchServiceProvider),
                URLQueryItem(name: "related", value: true.description),
                URLQueryItem(name: "mode", value: DetailMode.normal.rawValue),
                URLQueryItem(name: "limit", value: limit.description),
            ]
        )
    }

    static func newsArticles(limit: Int) -> Endpoint {
        return Endpoint(
            host: "api.spaceflightnewsapi.net",
            version: "v4",
            path: "articles",
            queryItems: [
                URLQueryItem(name: "limit", value: limit.description),
                URLQueryItem(name: "search", value: launchServiceProvider),
            ]
        )
    }
}
