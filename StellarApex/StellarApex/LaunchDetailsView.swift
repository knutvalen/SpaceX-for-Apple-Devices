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
                if let patch = launch.patches?.first?.imageURL {
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

                if let name = launch.name {
                    VStack(alignment: .leading) {
                        Text("Name")
                            .font(.headline)

                        Text(name)
                            .font(.subheadline)
                    }
                }

                if let status = launch.status?.name {
                    VStack(alignment: .leading) {
                        Text("Status")
                            .font(.headline)

                        Text(status)
                            .font(.subheadline)
                    }
                }

                if let launchDate = launch.net?.toStellarApexDateString() {
                    VStack(alignment: .leading) {
                        Text("Launch date")
                            .font(.headline)

                        Text(launchDate)
                            .font(.subheadline)
                    }
                }

                if let missionName = launch.mission?.name {
                    VStack(alignment: .leading) {
                        Text("Mission name")
                            .font(.headline)

                        Text(missionName)
                            .font(.subheadline)
                    }
                }

                if let missionType = launch.mission?.type {
                    VStack(alignment: .leading) {
                        Text("Mission type")
                            .font(.headline)

                        Text(missionType)
                            .font(.subheadline)
                    }
                }

                if let missionDescription = launch.mission?.description {
                    VStack(alignment: .leading) {
                        Text("Mission description")
                            .font(.headline)

                        Text(missionDescription)
                            .font(.subheadline)
                    }
                }

                if let orbit = launch.mission?.orbit?.name {
                    VStack(alignment: .leading) {
                        Text("Orbit")
                            .font(.headline)

                        Text(orbit)
                            .font(.subheadline)
                    }
                }

                if let lastUpdated = launch.lastUpdated {
                    VStack(alignment: .leading) {
                        Text("Details updated")
                            .font(.headline)

                        Text(
                            Date.RelativeFormatStyle(
                                presentation: .named,
                                capitalizationContext: .beginningOfSentence
                            )
                            .format(lastUpdated)
                        )
                        .font(.subheadline)
                    }
                }

                #if !os(watchOS)
                    VStack(alignment: .leading) {
                        Text("Stream")
                            .font(.headline)

                        if let url = launch.videos?.first(where: { $0.source?.contains("youtube") ?? false })?.url {
                            let player = YouTubePlayer(stringLiteral: url)
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
