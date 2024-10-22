import Foundation

struct Endpoint {
    let version = "2.3.0"
    let path: String
    let queryItems: [URLQueryItem]
    static let launchServiceProvider = "SpaceX"

    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = buildConfiguration == .development ? "lldev.thespacedevs.com" : "ll.thespacedevs.com"
        urlComponents.path = "/\(version)/\(path)"
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

    static func launchDetails(for launchId: String) -> Endpoint {
        return Endpoint(
            path: "launches/\(launchId)",
            queryItems: [URLQueryItem(name: "mode", value: DetailMode.normal.rawValue)]
        )
    }

    static func nextLaunch() -> Endpoint {
        return Endpoint(
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
            path: "launches/previous",
            queryItems: [
                URLQueryItem(name: "lsp__name", value: launchServiceProvider),
                URLQueryItem(name: "related", value: true.description),
                URLQueryItem(name: "mode", value: DetailMode.normal.rawValue),
                URLQueryItem(name: "limit", value: limit.description),
            ]
        )
    }
}
