import Foundation

class HttpService: ObservableObject {
    let httpLogger: HttpLogger
    let urlSession = URLSession.shared

    init(logger: HttpLogger) {
        httpLogger = logger
    }

    func request(
        endpoint: Endpoint,
        method: HTTPMethod,
        ignoreCache: Bool,
        completion: @escaping (Result<Data, AppError>) -> Void
    ) {
        debugPrint(debugTag, "ignoreCache: \(ignoreCache)")
        guard let url = endpoint.url else {
            return completion(.failure(AppError.invalidURL))
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = ignoreCache ? .reloadIgnoringLocalCacheData : .returnCacheDataElseLoad

        httpLogger.intercept(request: request)

        urlSession.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(AppError.response(error)))
            }

            self.httpLogger.intercept(data: data, response: response, error: error)

            if let error {
                return completion(.failure(AppError.response(error)))
            }

            guard let data else {
                return completion(.failure(AppError.noData))
            }

            return completion(.success(data))
        }.resume()
    }
}
