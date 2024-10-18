//
//  ApiService.swift
//  SpaceX Launches
//
//  Created by Knut Valen on 19/09/2024.
//

import Foundation

final class ApiService: ObservableObject {
    let httpService: HttpService

    init(httpService: HttpService) {
        self.httpService = httpService
    }

    func getLaunchDetails(for launchId: String, completion: @escaping (Result<LaunchDetails, AppError>) -> Void) {
        httpService.request(
            endpoint: .launchDetails(for: launchId),
            method: .get
        ) { result in
            if case let .failure(error) = result {
                return completion(.failure(error))
            }

            if case let .success(data) = result {
                do {
                    if let dataAsJson = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        var launchDetailsJson = [
                            "id": dataAsJson.value(forKey: "id"),
                            "lastUpdated": dataAsJson.value(forKey: "last_updated"),
                            "launchServiceProvider": [
                                "name": dataAsJson.value(forKeyPath: "launch_service_provider.name"),
                                "description": dataAsJson.value(forKeyPath: "launch_service_provider.description"),
                                "url": dataAsJson.value(forKeyPath: "launch_service_provider.info_url"),
                                "logo": dataAsJson.value(forKeyPath: "launch_service_provider.logo.image_url"),
                            ],
                            "name": dataAsJson.value(forKey: "name"),
                            "net": dataAsJson.value(forKey: "net"),
                            "netPrecision": dataAsJson.value(forKeyPath: "net_precision.name"),
                            "status": [
                                "name": dataAsJson.value(forKeyPath: "status.name"),
                                "description": dataAsJson.value(forKeyPath: "status.description"),
                            ],
                            "webcasts": dataAsJson.value(forKey: "vid_urls"),
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
                        decoder.dateDecodingStrategy = .iso8601

                        let launchDetails = try decoder.decode(LaunchDetails.self, from: launchDetailsJsonData)
                        completion(.success(launchDetails))
                    }
                } catch {
                    completion(.failure(AppError.decoding(error)))
                }
            }
        }
    }

    func getNextLaunch(completion: @escaping (Result<NextLaunch, AppError>) -> Void) {
        httpService.request(
            endpoint: .nextLaunch(),
            method: .get
        ) { result in
            if case let .failure(error) = result {
                return completion(.failure(error))
            }

            if case let .success(data) = result {
                do {
                    if let dataAsJson = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                       let firstResult = (dataAsJson.value(forKey: "results") as? [Any])?[0] as? NSDictionary
                    {
                        let nextLaunchJson = [
                            "id": firstResult.value(forKey: "id"),
                            "name": firstResult.value(forKey: "name"),
                            "webcast": firstResult.value(forKey: "vid_urls.0"),
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
                    return completion(.failure(AppError.decoding(error)))
                }
            }
        }
    }

    func getPreviousLaunches() {}
}
