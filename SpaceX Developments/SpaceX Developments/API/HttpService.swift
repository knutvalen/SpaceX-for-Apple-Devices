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
        ignoreCache: Bool
    ) async -> Result<Data, AppError> {
        guard let url = endpoint.url else {
            return .failure(AppError.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = ignoreCache ? .reloadIgnoringLocalCacheData : .returnCacheDataElseLoad

        httpLogger.intercept(request: request)

        do {
            let (data, response) = try await urlSession.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                let error = AppError.response()
                return .failure(error)
            }

            httpLogger.intercept(response: response, data: data)

            return .success(data)
        } catch {
            return .failure(AppError.response(error))
        }
    }
}
