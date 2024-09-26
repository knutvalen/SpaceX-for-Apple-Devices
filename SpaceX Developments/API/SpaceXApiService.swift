//
//  SpaceXApiService.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 19/09/2024.
//

import Foundation

let baseURL: String = buildEnvironment == .development ? "https://lldev.thespacedevs.com" : "https://ll.thespacedevs.com"
let version: String = "2.2.0"

let httpLogger: HTTPLogger = .init(simpleLog: false, redactableHeaders: [], redactHeaders: false, hideBody: false, prettyPrintBody: true)

@Observable
class SpaceXApiService: SpaceXApiInterface {
    func getNextLaunch(completion: @escaping (Result<NextLaunch, AppError>) -> Void) {
        guard var url = URL(string: "\(baseURL)/\(version)/launch/upcoming") else {
            completion(.failure(AppError.invalidPath))
            return
        }

        url.append(queryItems: [
            URLQueryItem(name: "lsp__name", value: "SpaceX"),
            URLQueryItem(name: "related", value: "true"),
            URLQueryItem(name: "mode", value: "detailed"),
            URLQueryItem(name: "limit", value: "1"),
        ])

        let request = createRequest(url: url, httpMethod: .get)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                return
            }

            httpLogger.intercept(data: data, response: response, error: error)

            guard let data else {
                if let error {
                    completion(.failure(AppError.response(error)))
                } else {
                    completion(.failure(AppError.noData))
                }
                return
            }

            do {
                if let dataAsJson = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                   let firstResult = (dataAsJson.value(forKey: "results") as? [Any])?[0] as? NSDictionary
                {
                    let nextLaunchJson = [
                        "id": firstResult.value(forKey: "id"),
                        "name": firstResult.value(forKey: "name"),
                        "webcast": firstResult.value(forKey: "vidURLs.0"),
                        "netPrecision": firstResult.value(forKeyPath: "net_precision.name"),
                        "net": firstResult.value(forKey: "net"),
                    ]

                    let nextLaunchJsonData = try JSONSerialization.data(withJSONObject: nextLaunchJson, options: [])

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601

                    let nextLaunch = try decoder.decode(NextLaunch.self, from: nextLaunchJsonData)
                    completion(.success(nextLaunch))
                }

            } catch {
                completion(.failure(AppError.decoding(error)))
                return
            }

        }.resume()
    }
}

private func createRequest(url: URL, httpMethod: HTTPMethod) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod.rawValue
    return request
}
