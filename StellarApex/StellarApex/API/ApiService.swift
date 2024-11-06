import Foundation

final class ApiService: ObservableObject {
    private let httpService: HttpService

    private let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        if let date = formatter.date(from: dateString) { return date }

        formatter.formatOptions.insert(.withFractionalSeconds)

        if let date = formatter.date(from: dateString) { return date }

        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
    }

    init(httpService: HttpService) {
        self.httpService = httpService
    }

    func getLaunchDetails(for launchId: String, ignoreCache: Bool) async -> Result<LaunchDetails, AppError> {
        let result = await httpService.request(
            endpoint: .launchDetails(for: launchId),
            method: .get,
            ignoreCache: ignoreCache
        )

        switch result {
        case let .success(data):
            do {
                if let dataAsJson = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    var launchDetailsJson = [
                        "id": dataAsJson.value(forKey: "id"),
                        "lastUpdated": dataAsJson.value(forKey: "last_updated"),
                        "name": dataAsJson.value(forKey: "name"),
                        "net": dataAsJson.value(forKey: "net"),
                        "netPrecision": dataAsJson.value(forKeyPath: "net_precision.name"),
                        "status": [
                            "name": dataAsJson.value(forKeyPath: "status.name"),
                            "description": dataAsJson.value(forKeyPath: "status.description"),
                        ],
                        "webcasts": dataAsJson.value(forKey: "vid_urls") as? [NSDictionary],
                        "mission": [
                            "description": dataAsJson.value(forKeyPath: "mission.description"),
                            "name": dataAsJson.value(forKeyPath: "mission.name"),
                            "orbit": dataAsJson.value(forKeyPath: "mission.orbit.name"),
                            "type": dataAsJson.value(forKeyPath: "mission.type"),
                        ],
                    ]

                    if let missionPatches = dataAsJson.value(forKey: "mission_patches") as? [NSDictionary] {
                        let patch = missionPatches.first?.value(forKey: "image_url") as? String
                        launchDetailsJson.merge(["patch": patch]) { _, new in new }
                    }

                    let launchDetailsJsonData = try JSONSerialization.data(withJSONObject: launchDetailsJson, options: [])

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = dateDecodingStrategy

                    let launchDetails = try decoder.decode(LaunchDetails.self, from: launchDetailsJsonData)
                    return .success(launchDetails)
                }
            } catch {
                return .failure(AppError.decoding(error))
            }

        case let .failure(error):
            return .failure(error)
        }

        return .failure(AppError.unknown)
    }

    func getNextLaunch(ignoreCache: Bool) async -> Result<LaunchOverview, AppError> {
        let result = await httpService.request(
            endpoint: .nextLaunch(),
            method: .get,
            ignoreCache: ignoreCache
        )

        switch result {
        case let .success(data):
            do {
                if let dataAsJson = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                   let firstResult = (dataAsJson.value(forKey: "results") as? [Any])?[0] as? NSDictionary
                {
                    let nextLaunchJson = [
                        "id": firstResult.value(forKey: "id"),
                        "name": firstResult.value(forKey: "name"),
                        "netPrecision": firstResult.value(forKeyPath: "net_precision.name"),
                        "net": firstResult.value(forKey: "net"),
                        "launchServiceProvider": [
                            "id": firstResult.value(forKeyPath: "launch_service_provider.id"),
                            "name": firstResult.value(forKeyPath: "launch_service_provider.name"),
                            "url": firstResult.value(forKeyPath: "launch_service_provider.info_url"),
                        ],
                    ]

                    let nextLaunchJsonData = try JSONSerialization.data(withJSONObject: nextLaunchJson)

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = dateDecodingStrategy

                    let nextLaunch = try decoder.decode(LaunchOverview.self, from: nextLaunchJsonData)
                    return .success(nextLaunch)
                }
            } catch {
                return .failure(AppError.decoding(error))
            }

        case let .failure(error):
            return .failure(error)
        }

        return .failure(AppError.unknown)
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
                if let dataAsJson = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                   let results = dataAsJson.value(forKey: "results") as? [NSDictionary]
                {
                    let launches: [LaunchOverview] = try results.map { result in
                        let launchJson = [
                            "id": result.value(forKey: "id"),
                            "name": result.value(forKey: "name"),
                            "netPrecision": result.value(forKeyPath: "net_precision.name"),
                            "net": result.value(forKey: "net"),
                            "launchServiceProvider": [
                                "id": result.value(forKeyPath: "launch_service_provider.id"),
                                "name": result.value(forKeyPath: "launch_service_provider.name"),
                                "url": result.value(forKeyPath: "launch_service_provider.info_url"),
                            ],
                        ]

                        let launchJsonData = try JSONSerialization.data(withJSONObject: launchJson)

                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = self.dateDecodingStrategy

                        let launch = try decoder.decode(LaunchOverview.self, from: launchJsonData)
                        return launch
                    }

                    return .success(launches)
                }
            } catch {
                return .failure(AppError.decoding(error))
            }

        case let .failure(error):
            return .failure(error)
        }

        return .failure(AppError.unknown)
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
                if let dataAsJson = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                   let results = dataAsJson.value(forKey: "results") as? [NSDictionary]
                {
                    let news: [NewsArticle] = try results.map { result in
                        var newsArticleJson = [
                            "id": result.value(forKey: "id"),
                            "title": result.value(forKey: "title"),
                            "newsUrl": result.value(forKey: "url"),
                            "imageUrl": result.value(forKey: "image_url"),
                            "newsSite": result.value(forKey: "news_site"),
                            "summary": result.value(forKey: "summary"),
                            "publishedAt": result.value(forKey: "published_at"),
                            "updatedAt": result.value(forKey: "updated_at"),
                            "featured": result.value(forKey: "featured"),
                            "launches": result.value(forKey: "launches"),
                        ]

                        if let launches = result.value(forKey: "launches") as? [NSDictionary] {
                            let ids = launches.map { launch in
                                launch.value(forKey: "launch_id")
                            }
                            newsArticleJson.merge(["launches": ids]) { _, new in new }
                        }

                        let newsArticleJsonData = try JSONSerialization.data(withJSONObject: newsArticleJson)

                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = self.dateDecodingStrategy

                        let newsArticle = try decoder.decode(NewsArticle.self, from: newsArticleJsonData)
                        return newsArticle
                    }

                    return .success(news)
                }
            } catch {
                return .failure(AppError.decoding(error))
            }

        case let .failure(error):
            return .failure(error)
        }

        return .failure(AppError.unknown)
    }
}
