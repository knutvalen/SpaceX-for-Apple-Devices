import CachedAsyncImage
import SwiftUI
import YouTubePlayerKit

struct NextLaunchView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject private var viewModel = LaunchViewModel()
    @Binding private var tabSelection: Selection
    @Binding private var launchId: String?
    @Binding private var preferredColumn: NavigationSplitViewColumn
    @Environment(\.scenePhase) var scenePhase
    @State private var youTubePlayer: YouTubePlayer?

    init(
        tabSelection: Binding<Selection>,
        launchId: Binding<String?>,
        preferredColumn: Binding<NavigationSplitViewColumn>
    ) {
        _tabSelection = tabSelection
        _launchId = launchId
        _preferredColumn = preferredColumn
    }

    var body: some View {
        if viewModel.nextLaunch != nil,
           viewModel.timeLeft != nil
        {
            NavigationSplitView(preferredCompactColumn: $preferredColumn) {
                List {
                    VStack(alignment: .leading, spacing: 16) {
                        CountdownView(viewModel: viewModel)
                            .padding(.horizontal)
                            .padding(.top)

                        if let logo = viewModel.nextLaunch?.launchServiceProvider?.logo?.url {
                            HStack(alignment: .center) {
                                Spacer()

                                CachedAsyncImage(url: URL(string: logo)) { phase in
                                    switch phase {
                                    case let .success(image):
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 120)

                                    case .failure:
                                        EmptyView()

                                    case .empty:
                                        ProgressView()
                                            .controlSize(.small)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                                    @unknown default:
                                        EmptyView()
                                    }
                                }

                                Spacer()
                            }
                        }

                        if let youTubePlayer = youTubePlayer {
                            YouTubePlayerView(youTubePlayer) { state in
                                switch state {
                                case .idle:
                                    ProgressView {
                                        Text("Loading YouTube player")
                                    }

                                case .ready:
                                    EmptyView()

                                case .error:
                                    Text("YouTube player failed to load")
                                }
                            }
                            .aspectRatio(contentMode: .fit)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 0)
                        }

                        Text("Rocket")
                            .font(.largeTitle)
                            .padding(.horizontal)
                            .padding(.top)

                        RocketView(viewModel: viewModel)
                            .environmentObject(themeManager)
                            .padding(.horizontal)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Mission")
                            .font(.largeTitle)
                            .padding(.horizontal)
                            .padding(.top)

                        MissionView(viewModel: viewModel)
                            .environmentObject(themeManager)
                            .padding(.horizontal)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Launch site")
                            .font(.largeTitle)
                            .padding(.horizontal)
                            .padding(.top)

                        LaunchSiteView(viewModel: viewModel)
                            .environmentObject(themeManager)
                            .padding(.horizontal)
                            .fixedSize(horizontal: false, vertical: true)

                        HStack {
                            Spacer()

                            if let launch = viewModel.nextLaunch {
                                Button {
                                    launchId = launch.id
                                    preferredColumn = .detail
                                } label: {
                                    Image("rocket-template-tiny")
                                    Text("Details")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .padding(.bottom)
                }
                .listStyle(.inset)
                .navigationTitle("Next Launch")
                .refreshable {
                    await viewModel.getNextLaunch(ignoreCache: true)

                    if let url = viewModel.nextLaunch?.videos?.first(where: {
                        $0.source?.contains("youtube") ?? false
                    })?.url {
                        youTubePlayer?.source = .url(url)
                    }

                    do {
                        try await youTubePlayer?.reload()
                    } catch {
                        debugPrint("Error reloading YouTube player: \(error)")
                    }
                }
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active && viewModel.timeLeft != nil {
                        Task {
                            await viewModel.getNextLaunch(ignoreCache: false)
                        }
                    }
                }
                .onAppear {
                    if let url = viewModel.nextLaunch?.videos?.first(where: {
                        $0.source?.contains("youtube") ?? false
                    })?.url {
                        youTubePlayer = .init(
                            source: .url(url),
                            configuration: .init(autoPlay: false)
                        )
                    }
                }
            } detail: {
                ZStack {
                    if let id = Binding($launchId) {
                        LaunchDetailsView(launchId: id)
                    } else {
                        ContentUnavailableView("Select a launch", image: "rocket-template-1x")
                    }
                }
            }
        } else {
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    ProgressView {
                        Text("Loading next launch")
                    }
                    .controlSize(.large)
                    .onAppear {
                        Task {
                            await viewModel.getNextLaunch(ignoreCache: false)
                        }
                    }

                    Spacer()
                }

                Spacer()
            }
        }
    }
}

#Preview {
    NextLaunchView(
        tabSelection: .constant(.nextLaunch),
        launchId: .constant(nil),
        preferredColumn: .constant(.sidebar)
    )
    .environmentObject(ThemeManager())
}
