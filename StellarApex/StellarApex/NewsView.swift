import CachedAsyncImage
import Foundation
import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openURL) private var openURL
    @State private var displayingSheet = false
    @State private var newsUrl: URL?
    @State var preferredColumn = NavigationSplitViewColumn.sidebar

    private func relativeTime(from date: Date) -> String? {
        let now = Date()
        let seconds = Int(floor(date.timeIntervalSince1970 - now.timeIntervalSince1970))

        guard let dateRelativeToNow = Calendar.current.date(
            byAdding: .second,
            value: seconds,
            to: now
        ) else { return nil }

        return dateRelativeToNow.formatted(.relative(presentation: .named, unitsStyle: .wide))
    }

    var body: some View {
        if let news = viewModel.news {
            NavigationSplitView(preferredCompactColumn: $preferredColumn) {
                List(news) { newsArticle in
                    VStack {
                        CachedAsyncImage(url: newsArticle.imageUrl) { phase in
                            switch phase {
                            case let .success(image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)

                            case .failure:
                                EmptyView()

                            case .empty:
                                ProgressView()
                                    .controlSize(.regular)

                            @unknown default:
                                EmptyView()
                            }
                        }

                        HStack {
                            Text(newsArticle.title)
                                .font(.headline)

                            Spacer()
                        }

                        VStack {
                            HStack {
                                Text(newsArticle.newsSite)
                                    .font(.caption)

                                Spacer()
                            }

                            if let relativeTime = relativeTime(from: newsArticle.publishedAt) {
                                HStack {
                                    Text("Published \(relativeTime)")
                                        .font(.caption2)

                                    Spacer()
                                }
                            }

                            if let relativeTime = relativeTime(from: newsArticle.updatedAt) {
                                HStack {
                                    Text("Updated \(relativeTime)")
                                        .font(.caption2)

                                    Spacer()
                                }
                            }
                        }
                        .padding(.vertical, 4)

                        HStack {
                            Text(newsArticle.summary)
                            Spacer()
                        }

                        /*
                         if newsArticle.launches.isEmpty == false {
                             HStack {
                                 VStack(alignment: .leading) {
                                     Text("Related launches")
                                         .font(.headline)

                                     ForEach(newsArticle.launches, id: \.self) { launchId in
                                         Button {

                                         } label: {
                                             HStack {
                                                 Image("rocket-template-tiny")
                                                 Text("Details")
                                             }
                                         }
                                         .buttonStyle(.borderless)
                                     }
                                 }

                                 Spacer()
                             }
                             .padding(.top, 4)
                         }
                         */

                        #if !os(watchOS)
                            HStack {
                                Spacer()

                                Button {
                                    newsUrl = newsArticle.newsUrl
                                    preferredColumn = .detail
                                } label: {
                                    HStack {
                                        Image(systemName: "newspaper")
                                        Text("Details")
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        #endif
                    }
                    #if !os(watchOS)
                    .listRowSeparator(.hidden)
                    .padding(16)
                    .background(themeManager.selectedTheme.cardColor)
                    .cornerRadius(12)
                    .shadow(color: themeManager.selectedTheme.shadowColor, radius: 2, x: 1, y: 2)
                    #else
                    .padding(8)
                    #endif
                }
                #if !os(watchOS)
                .listStyle(.inset)
                .padding(.horizontal, -8)
                #endif
                .navigationTitle("News")
                .refreshable {
                    await viewModel.getNews(ignoreCache: true)
                }
            } detail: {
                ZStack {
                    if let url = newsUrl {
                        #if !os(watchOS)
                            WebView(url: url)
                        #endif
                    } else {
                        ContentUnavailableView("Select a news article", systemImage: "newspaper")
                    }
                }
            }
        } else {
            VStack {
                Spacer()

                ProgressView()
                    .controlSize(.large)

                Spacer()
            }
        }
    }
}

#Preview {
    NewsView()
        .environmentObject(ThemeManager())
}
