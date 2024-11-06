//
//  NewsViewModel.swift
//  SpaceX Developments
//
//  Created by Knut Valen on 25/10/2024.
//

import Foundation
import SwiftUI

class NewsViewModel: ObservableObject {
    @StateObject var appState = AppState.singleton
    @Published var news: [NewsArticle]?
    var launchServiceProviders: [LaunchServiceProvider]?

    init() {
        Task {
            if launchServiceProviders == nil {
                try await loadLaunchServiceProviders()
            }

            await getNews(ignoreCache: false)
        }
    }

    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appendingPathComponent("LaunchServiceProviders")
    }

    func loadLaunchServiceProviders() async throws {
        let task = Task<[LaunchServiceProvider], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let lsps = try JSONDecoder().decode([LaunchServiceProvider].self, from: data)
            return lsps
        }
        let lsps = try await task.value
        launchServiceProviders = lsps
    }

    func getNews(ignoreCache: Bool) async {
        guard let launchServiceProviders else { return }

        let result = await appState.api.getNewsArticles(
            launchServiceProviders: launchServiceProviders,
            ignoreCache: ignoreCache
        )

        switch result {
        case let .success(articles):
            DispatchQueue.main.async {
                self.news = articles
            }

        case let .failure(error):
            debugPrint(error)
        }
    }
}
