//
//  SpaceXApiEndpoint.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 17/10/2024.
//

import Foundation

struct SpaceXApiEndpoint {
    let url: URL

    static func launchDetails(for launchId: String) -> SpaceXApiEndpoint {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = buildConfiguration == .development ? "lldev.thespacedevs.com" : "ll.thespacedevs.com"
        let version = "2.3.0"
        urlComponents.path = "/\(version)/launches/\(launchId)"
        urlComponents.queryItems = [
            URLQueryItem(name: "mode", value: "detailed"),
        ]

        guard let url = urlComponents.url else {
            fatalError("Failed to build URL for SpaceX API endpoint")
        }

        return SpaceXApiEndpoint(
            url: url
        )
    }
}
