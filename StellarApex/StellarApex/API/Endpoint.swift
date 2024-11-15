import Foundation

struct Endpoint {
    let host: String
    let version: String
    let path: String
    let queryItems: [URLQueryItem]

    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/\(version)/\(path)"
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}

extension Endpoint {
    static let host: String = {
        #if DEBUG
            return "ll.thespacedevs.com"
        #else
            return "ll.thespacedevs.com"
        #endif
    }()

    static func launchDetails(for launchId: String) -> Endpoint {
        return Endpoint(
            host: host,
            version: "2.3.0",
            path: "launches/\(launchId)",
            queryItems: [URLQueryItem(name: "mode", value: DetailMode.normal.rawValue)]
        )
    }

    static func nextLaunch() -> Endpoint {
        return Endpoint(
            host: host,
            version: "2.3.0",
            path: "launches/upcoming",
            queryItems: [
                URLQueryItem(name: "mode", value: DetailMode.detailed.rawValue),
                URLQueryItem(name: "limit", value: 1.description),
            ]
        )
    }

    static func previousLaunches() -> Endpoint {
        return Endpoint(
            host: host,
            version: "2.3.0",
            path: "launches/previous",
            queryItems: [
                URLQueryItem(name: "mode", value: DetailMode.normal.rawValue),
                URLQueryItem(name: "limit", value: 50.description),
            ]
        )
    }

    static func newsArticles(launchServiceProviders: [LaunchServiceProvider]) -> Endpoint {
        return Endpoint(
            host: "api.spaceflightnewsapi.net",
            version: "v4",
            path: "articles",
            queryItems: [
                URLQueryItem(name: "limit", value: 50.description),
                URLQueryItem(name: "title_contains_one", value: launchServiceProviders.map(\.name).joined(separator: ",")),
                URLQueryItem(name: "summary_contains_one", value: launchServiceProviders.map(\.name).joined(separator: ",")),
            ]
        )
    }
}
