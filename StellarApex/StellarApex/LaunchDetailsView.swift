import CachedAsyncImage
import SwiftUI
#if !os(watchOS)
    import YouTubePlayerKit
#endif

struct LaunchDetailsView: View {
    @StateObject private var viewModel = LaunchDetailsViewModel()
    @Binding var launchId: String
    @Environment(\.openURL) private var openURL

    private func minWidthClamp() -> CGFloat {
        #if !os(watchOS)
            let calc = UIScreen.main.bounds.width - 80
        #else
            let calc: CGFloat = WKInterfaceDevice().screenBounds.width
        #endif

        if calc < 300 {
            return calc
        } else {
            return 300
        }
    }

    var body: some View {
        if let launch = viewModel.launchDetails,
           launch.id == launchId
        {
            List {
                if let patch = launch.patch {
                    HStack {
                        Spacer()

                        CachedAsyncImage(url: URL(string: patch)) { phase in
                            switch phase {
                            case let .success(image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                #if !os(watchOS)
                                    .frame(width: minWidthClamp(), height: minWidthClamp())
                                #endif

                            case .failure:
                                EmptyView()

                            case .empty:
                                ProgressView()
                                    .controlSize(.regular)
                                #if !os(watchOS)
                                    .frame(width: minWidthClamp(), height: minWidthClamp())
                                #endif

                            @unknown default:
                                EmptyView()
                            }
                        }

                        Spacer()
                    }
                }

                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.headline)

                    Text(launch.name)
                        .font(.subheadline)
                }

                VStack(alignment: .leading) {
                    Text("Status")
                        .font(.headline)

                    Text(launch.status.name)
                        .font(.subheadline)
                }

                if let launchDate = launch.net.toLaunch(precision: launch.netPrecision) {
                    VStack(alignment: .leading) {
                        Text("Launch date")
                            .font(.headline)

                        Text(launchDate)
                            .font(.subheadline)
                    }

                    VStack(alignment: .leading) {
                        Text("Launch date precision")
                            .font(.headline)

                        Text(launch.netPrecision.rawValue)
                            .font(.subheadline)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Mission name")
                        .font(.headline)

                    Text(launch.mission.name)
                        .font(.subheadline)
                }

                VStack(alignment: .leading) {
                    Text("Mission type")
                        .font(.headline)

                    Text(launch.mission.type)
                        .font(.subheadline)
                }

                if let missionDescription = launch.mission.description {
                    VStack(alignment: .leading) {
                        Text("Mission description")
                            .font(.headline)

                        Text(missionDescription)
                            .font(.subheadline)
                    }
                }

                VStack(alignment: .leading) {
                    Text("Orbit")
                        .font(.headline)

                    Text(launch.mission.orbit)
                        .font(.subheadline)
                }

                VStack(alignment: .leading) {
                    Text("Details updated")
                        .font(.headline)

                    Text(
                        Date.RelativeFormatStyle(
                            presentation: .named,
                            capitalizationContext: .beginningOfSentence
                        )
                        .format(launch.lastUpdated)
                    )
                    .font(.subheadline)
                }

                #if !os(watchOS)
                    VStack(alignment: .leading) {
                        Text("Stream")
                            .font(.headline)

                        if let webcast = launch.webcasts.first(where: { webcast in
                            webcast.source?.contains("youtube") ?? false // TODO: rewrite using $0
                        }) {
                            let player = YouTubePlayer(stringLiteral: webcast.url)
                            YouTubePlayerView(player) { state in
                                switch state {
                                case .idle:
                                    ProgressView()

                                case .ready:
                                    EmptyView()

                                case .error:
                                    Text("YouTube player could not be loaded.")
                                }
                            }
                            .aspectRatio(contentMode: .fit)
                        } else {
                            Text("No stream available")
                        }
                    }
                #endif
            }
            #if !os(watchOS)
            .listStyle(.inset)
            #endif
            .refreshable {
                await viewModel.getLaunchDetails(for: launchId, ignoreCache: true)
            }
        } else {
            VStack {
                Spacer()

                ProgressView()
                    .controlSize(.large)

                Spacer()
            }.onChange(of: launchId, initial: true) {
                Task {
                    await viewModel.getLaunchDetails(for: launchId, ignoreCache: false)
                }
            }
        }
    }
}

#Preview {
    LaunchDetailsView(
        launchId: .constant("9d576892-dcf0-472b-92d1-37053ff549ab")
    )
}
