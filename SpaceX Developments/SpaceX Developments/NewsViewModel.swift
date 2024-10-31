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
    let initialLimit = 10
    var limit: Int

    init() {
        limit = initialLimit

        Task {
            await getNews(ignoreCache: false)
        }
    }

    func getNews(ignoreCache: Bool) async {
        let result = await appState.api.getNewsArticles(limit: limit, ignoreCache: ignoreCache)

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
