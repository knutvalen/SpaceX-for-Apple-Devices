import Foundation
import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NewsViewModel()
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openURL) private var openURL

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
            NavigationStack {
                List(news) { newsArticle in
                    VStack {
                        AsyncImage(url: newsArticle.imageUrl) { phase in
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
                                             //TODO: navigate to launch details from here
                                         } label: {
                                             HStack {
                                                 Image("rocket-template")
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

                        HStack {
                            Spacer()

                            Button {
                                openURL(newsArticle.newsUrl)
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.up.forward.app")
                                    Text("Details")
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .listStyle(.inset)
                .navigationTitle("News")
                .refreshable {
                    viewModel.getNews(ignoreCache: true)
                }
            }
        } else {
            VStack {
                Spacer()

                ProgressView()
                    .controlSize(.large)

                Spacer()
            }.onAppear {
                viewModel.getNews(ignoreCache: false)
            }
        }
    }
}

#Preview {
    NewsView()
}
