//
//  Endpoint.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 17/10/2024.
//

import Foundation

struct Endpoint {
    let version = "2.3.0"
    let path: String
    let queryItems: [URLQueryItem]

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
            queryItems: [URLQueryItem(name: "mode", value: "detailed")]
        )
    }

    static func nextLaunch() -> Endpoint {
        return Endpoint(
            path: "launches/upcoming",
            queryItems: [
                URLQueryItem(name: "lsp__name", value: "SpaceX"),
                URLQueryItem(name: "related", value: "true"),
                URLQueryItem(name: "mode", value: "detailed"),
                URLQueryItem(name: "limit", value: "1"),
            ]
        )
    }
}
