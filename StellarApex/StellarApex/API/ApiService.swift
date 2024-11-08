import Foundation

class ApiService: IApiService, ObservableObject {
    private let httpService: HttpService
    private let decoder: JSONDecoder

    init(httpService: HttpService) {
        self.httpService = httpService
        decoder = JSONDecoder()
        do {
            decoder.dateDecodingStrategy = try JSONDecoder.DateDecodingStrategy.launchLibrary()
        } catch {
            debugPrint("Failed to set date decoding strategy: \(error.localizedDescription)")
        }
    }

    func getNextLaunch(ignoreCache: Bool) async -> Result<LaunchDetails, AppError> {
        let result = await httpService.request(
            endpoint: .nextLaunch(),
            method: .get,
            ignoreCache: ignoreCache
        )

        switch result {
        case let .success(data):
            do {
                guard let firstResult = try (
                    (JSONSerialization.jsonObject(with: data) as? NSDictionary)?.value(forKey: "results") as? [Any]
                )?.first as? NSDictionary else {
                    return .failure(AppError.unknown)
                }

                let nextLaunchData = try JSONSerialization.data(withJSONObject: firstResult)
                let nextLaunch = try decoder.decode(LaunchDetails.self, from: nextLaunchData)
                return .success(nextLaunch)
            } catch {
                return .failure(AppError.decoding(error))
            }

        case let .failure(error):
            return .failure(error)
        }
    }

    func getPreviousLaunches(ignoreCache: Bool) async -> Result<[LaunchOverview], AppError> {
        let result = await httpService.request(
            endpoint: .previousLaunches(),
            method: .get,
            ignoreCache: ignoreCache
        )

        switch result {
        case let .success(data):
            do {
                guard let results = try (JSONSerialization.jsonObject(with: data) as? NSDictionary)?.value(forKey: "results") as? [Any] else {
                    return .failure(AppError.unknown)
                }

                let launchesData = try JSONSerialization.data(withJSONObject: results)
                let launches = try decoder.decode([LaunchOverview].self, from: launchesData)
                return .success(launches)
            } catch {
                return .failure(AppError.decoding(error))
            }

        case let .failure(error):
            return .failure(error)
        }
    }

    func getLaunchDetails(for id: String, ignoreCache: Bool) async -> Result<LaunchDetails, AppError> {
        let result = await httpService.request(
            endpoint: .launchDetails(for: id),
            method: .get,
            ignoreCache: ignoreCache
        )

        switch result {
        case let .success(data):
            do {
                let launchDetails = try decoder.decode(LaunchDetails.self, from: data)
                return .success(launchDetails)
            } catch {
                return .failure(AppError.decoding(error))
            }

        case let .failure(error):
            return .failure(error)
        }
    }

    func getNewsArticles(launchServiceProviders: [LaunchServiceProvider], ignoreCache: Bool) async -> Result<[NewsArticle], AppError> {
        let result = await httpService.request(
            endpoint: .newsArticles(launchServiceProviders: launchServiceProviders),
            method: .get,
            ignoreCache: ignoreCache
        )

        switch result {
        case let .success(data):
            do {
                guard let results = try (JSONSerialization.jsonObject(with: data) as? NSDictionary)?.value(forKey: "results") as? [Any] else {
                    return .failure(AppError.unknown)
                }

                let newsArticlesJsonData = try JSONSerialization.data(withJSONObject: results)
                let newsArticles = try decoder.decode([NewsArticle].self, from: newsArticlesJsonData)
                return .success(newsArticles)
            } catch {
                return .failure(AppError.decoding(error))
            }

        case let .failure(error):
            return .failure(error)
        }
    }
}
