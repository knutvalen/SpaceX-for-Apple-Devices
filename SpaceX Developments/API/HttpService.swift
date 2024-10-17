//
//  HttpService.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 10/10/2024.
//

import Foundation

class HttpService: ObservableObject {
    let httpLogger: HttpLogger

    init(logger: HttpLogger) {
        httpLogger = logger
    }

    func request(
        endpoint: SpaceXApiEndpoint,
        method: HTTPMethod,
        completion: @escaping (Result<Data, AppError>) -> Void
    ) {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = method.rawValue

        httpLogger.intercept(request: request)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(AppError.response(error)))
            }

            self.httpLogger.intercept(data: data, response: response, error: error)

            guard let data else {
                if let error {
                    return completion(.failure(AppError.response(error)))
                } else {
                    return completion(.failure(AppError.noData))
                }
            }

            return completion(.success(data))
        }.resume()
    }
}
